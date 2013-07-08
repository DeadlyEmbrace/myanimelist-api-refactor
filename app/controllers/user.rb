MyAnimeListApiRefactor::App.controllers :user do

  get :profile, map: '/user/:username/profile' do
  end

  get :animelist, map: '/user/:username/animelist' do
  end

  get :mangalist, map: '/user/:username/mangalist' do
  end

  get :history, map: '/user/:username/history' do
  end

end
