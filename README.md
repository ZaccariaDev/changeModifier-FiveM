# changeModifier-FiveM
[![Rejoignez-nous sur Discord](https://img.shields.io/badge/Discord-Rejoignez%20notre%20serveur-7289DA?style=for-the-badge&logo=discord)](https://discord.gg/cdtdMUQ3DD)

![changeModifier](https://i.ibb.co/8YG0FKg/image.png)

Bienvenue dans le projet **changeModifier** !

## Vidéo de démonstration

Cliquez sur l'image ci-dessous pour regarder la démonstration vidéo :

[![Regarder la vidéo](https://img.youtube.com/vi/AK1B8uVI6IY/0.jpg)](https://www.youtube.com/watch?v=AK1B8uVI6IY)

## Fonctionnement de changeModifier

**changeModifier** est un script qui permet de changer les modificateurs de cycle de temps dans le jeu. Il prend en charge plusieurs paramètres et utilise des touches spécifiques pour naviguer entre les modificateurs.

### Commande

La commande principale est `/changemodifier`, qui peut prendre plusieurs arguments.

#### Paramètres

- `--strength [force]` ou `-s [force]` : Définit la force du modificateur (par défaut : 0.8).
- `--default` ou `-d` : Réinitialise le modificateur au paramètre par défaut.
- `--info` ou `-i` : Affiche les informations sur les commandes disponibles.

#### Utilisation des touches

- Utilisez les flèches gauche et droite ou les touches **A** et **E** pour naviguer entre les modificateurs.
- Appuyez sur **Entrée** pour sélectionner le modificateur.
- Appuyez sur **Retour arrière** pour réinitialiser au modificateur par défaut.

### Informations supplémentaires

Pour plus d'informations, utilisez la commande `/changemodifier -i` dans le jeu.

Il est également possible de déclencher un événement client avec comme argument obligatoire le nom du modificateur et comme argument optionnel la force :

```lua
RegisterNetEvent('changeModifier:applyModifier')
AddEventHandler('changeModifier:applyModifier', function(modifier, handle)
    if tonumber(handle) then
        strength = handle
    end
    if modifier then
        handleTimecycleModifier(modifier)
    end
end)
```

[![Rejoignez-nous sur Discord](https://img.shields.io/badge/Discord-Rejoignez%20notre%20serveur-7289DA?style=for-the-badge&logo=discord)](https://discord.gg/cdtdMUQ3DD)
