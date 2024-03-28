# Рекомендации

* Для того чтобы лучше понять тестирование и научиться разным приемам читайте/ищите статьи по тестированию в других языках/продуктах. Большинство практик и примеров универсальные и никак не связаны с тем, что вы тестируете, разница лишь в инструментарии.
* Перед внедрением, когда вы уже попробовали и поняли необходимость использования тестов вам следует сразу же продумать и регламентировать
  * Подход к организации тестов - что тестировать, что нет, как называть модули с тестами, как именовать модули помощники. Это все нужно чтобы упростить работу с тестами в будущем.
  * Как вам валидировать "правильность" тестов, чтобы они были действительно полезными.

## Внедрение

* Если у вас в компании множество команд занимающихся тестированием, то вам следует:
  * Продумать схему обновления, рекомендую использовать релизный репозиторий и обновление через git
  * Возможно стоит создать свою версию движка на базе публичной версии, в которой вы будете собирать "помогаторы" тестирования для ваших продуктов.