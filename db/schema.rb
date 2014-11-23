# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141122234945) do

  create_table "ballot_entries", force: true do |t|
    t.integer  "rank"
    t.integer  "candidate_id"
    t.integer  "ballot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ballots", force: true do |t|
    t.integer  "currentPosition"
    t.integer  "voter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ballots", ["voter_id"], name: "index_ballots_on_voter_id"

  create_table "candidates", force: true do |t|
    t.string   "name"
    t.integer  "election_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidates", ["election_id"], name: "index_candidates_on_election_id"

  create_table "elections", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "quota"
    t.integer  "status",      default: 0
    t.date     "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voters", force: true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.integer  "election_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
