(ns books-api.core
  (:gen-class)
  (:require
   [ring.adapter.jetty :as jetty]
   [reitit.ring :as ring]
   [reitit.ring.coercion :as coercion]
   [reitit.ring.middleware.muuntaja :as muuntaja]
   [muuntaja.core :as m]))

(def books
  [{:id 1 :title "Programming Elixir" :author "Dave Thomas"}
   {:id 2 :title "Designing Elixir Systems with OTP" :author "John Hughes"}
   {:id 3 :title "Phoenix in Action" :author "Geoffrey Lessel"}])

(defn parse-int [value]
  (try
    (Integer/parseInt value)
    (catch Exception _
      nil)))

(defn list-books [_request]
  {:status 200
   :body books})

(defn get-book [request]
  (let [id-str (get-in request [:path-params :id])
        id (parse-int id-str)]
    (cond
      (nil? id)
      {:status 400 :body {:error "Invalid ID"}}

      :else
      (if-let [book (first (filter #(= (:id %) id) books))]
        {:status 200 :body book}
        {:status 404 :body {:error "Book not found"}}))))

(def app
  (ring/ring-handler
   (ring/router
    [["/api"
      ["/books" {:get list-books}]
      ["/books/:id" {:get get-book}]]]
    {:data
     {:muuntaja m/instance
      :middleware [muuntaja/format-middleware coercion/coerce-exceptions-middleware]}})))

(defn -main [& _args]
  (println "Starting Clojure API at http://localhost:8080")
  (jetty/run-jetty app {:port 8080 :join? true}))
