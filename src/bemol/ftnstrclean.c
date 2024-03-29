/* RMNLIB - Library of useful routines for C and FORTRAN programming
 * Copyright (C) 1975-2001  Division de Recherche en Prevision Numerique
 *                          Environnement Canada
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation,
 * version 2.1 of the License.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

//! Trim spaces at both ends of a string
int32_t ftnstrclean(
    char str[],
    int32_t lenstr
) {
    int32_t iinit = 0;
    int32_t i = iinit;
    while (str[i] == ' ' && i < lenstr) {
        i++;
    }

    if (i != iinit) {
        strcpy(str, str + i);
    }

    int32_t jinit = lenstr - 1;
    int32_t j = jinit;

    while (str[j] == ' ' && j >= 0) {
        j--;
    }

    if (j != jinit) {
        str[j + 1] = '\0';
    }

    return 0;
}
