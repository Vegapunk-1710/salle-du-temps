import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';
import { resolvers } from './resolvers.js';
import { typeDefs } from './schema.js';

const server = new ApolloServer({
    typeDefs,
    resolvers,
  });
const port = parseInt(process.env.PORT, 10) || 4000;
const { url } = await startStandaloneServer(server, {
  listen: { port:  port,},
}
);
  
console.log(`Server ready at: ${url}`);