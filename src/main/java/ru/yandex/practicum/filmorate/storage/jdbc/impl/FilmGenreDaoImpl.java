package ru.yandex.practicum.filmorate.storage.jdbc.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import ru.yandex.practicum.filmorate.model.Film;
import ru.yandex.practicum.filmorate.model.Genre;
import ru.yandex.practicum.filmorate.storage.jdbc.FilmGenreDao;
import ru.yandex.practicum.filmorate.storage.jdbc.GenreDao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

@Repository
public class FilmGenreDaoImpl implements FilmGenreDao {

    private final JdbcTemplate jdbcTemplate;
    private final GenreDao genreDao;

    @Autowired
    public FilmGenreDaoImpl(JdbcTemplate jdbcTemplate, GenreDao genreDao) {
        this.jdbcTemplate = jdbcTemplate;
        this.genreDao = genreDao;
    }

    @Override
    public Set<Genre> findAllByFilmId(Long id) {
        Set<Genre> genres = new HashSet<>();
        String sql = "select * from FILMS_GENRES G join GENRES G2 on G2.GENRE_ID = G.GENRE_ID " +
                "where film_id = ?";
        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, id);
        while (rs.next()) {
            genres.add(new Genre(rs.getInt("GENRE_ID"),
                    rs.getString("NAME")));
        }
        return genres;
    }

    @Override
    public void addNewGenreToFilm(Long filmId, Genre genre) {
        String sql = " insert into FILMS_GENRES(FILM_ID, GENRE_ID) values  (?, ?)";
        jdbcTemplate.update(sql, filmId, genre.getId());
    }

    @Override
    public void updateAllGenreByFilm(Film film) {
        if (film.getGenres() != null) {
            if (film.getGenres().isEmpty()){
                deleteAll(film);
                return;
            }
            // перед обновлением  удаляем устаревшие данные
            deleteAll(film);

//            String sqlUpdate = "insert into FILMS_GENRES(GENRE_ID, FILM_ID) values (?, ?)";

            StringBuilder sb = new StringBuilder("insert into FILMS_GENRES(GENRE_ID, FILM_ID) values ");

            for (Genre genre : film.getGenres()) {
                sb.append("(" + genre.getId() + ",")
                .append( film.getId() + "),");


/*                    if (genre.getName() == null) {
                        genre.setName(genreDao.findById(genre.getId()).get().getName());
                    }*/
            }
            String sql = sb.subSequence(0, sb.length()-1).toString();
            jdbcTemplate.update(sql);

            //////////////////////
/*            try (PreparedStatement ps = jdbcTemplate.getDataSource().getConnection().prepareStatement(sqlUpdate)) {
                for (Genre genre : film.getGenres()) {
                    ps.setInt(1, genre.getId());
                    ps.setLong(2, film.getId());
                    ps.addBatch();
*//*                    if (genre.getName() == null) {
                        genre.setName(genreDao.findById(genre.getId()).get().getName());
                    }*//*
                }
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }*/
        }
    }

    private void deleteAll(Film film) {
        final String sql = "delete from FILMS_GENRES where  FILM_ID = ?";
        jdbcTemplate.update(sql, film.getId());
    }
}
