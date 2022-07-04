package ru.yandex.practicum.filmorate.storage;

import ru.yandex.practicum.filmorate.model.Film;

import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface FilmStorage {


    Collection<Film> findAll();

    Optional<Film> findById(Long id);

    Optional<Film> create(Film film);

    Film updateFilm(Film film);

    List<Film> getMostPopular(Integer count, Integer genreId, Integer date);
}
