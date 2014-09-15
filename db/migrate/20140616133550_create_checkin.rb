class CreateCheckin < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE `checkins` (
        `id`          int(11)      NOT NULL AUTO_INCREMENT,
        `latitude`    double,
        `longitude`   double,
        `text`        varchar(255),
        `category`    enum('food_and_drinks', 'events', 'deals'),
        PRIMARY KEY   (`id`),
        KEY `index_checkins_on_latitude_and_longitude` (`latitude`,`longitude`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    }
  end

  def self.down
    drop_table :checkins
  end
end
