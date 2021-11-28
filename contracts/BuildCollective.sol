pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  struct Organisation{
    string name;
    address owner;
    address[] members;
    uint256 balance;
  }

  struct Bug {
    string BUG_title;
    string BUG_description;
    uint256 prize; 
    string[] proposition;  //les propositions donnée par chaque dévloppeur
    address[] proposers; // les dévloppeurs qui proposent une solution like overstackoverflow
    string fix;     // solution
    bool suspending;   //déscion en attente
    bool resolved;  //beug résolu
    uint256 project_ID; // le projet a qui le beug est associer
  }

// le projet on lui assosc
  struct Project{
    string name;
    address owner;
    address[] contributors;
    uint256 balance;
  }

  mapping(address => User) private users;
  mapping(address => Organisation) private orgs; 
  mapping(address => Project[]) private projects;
  mapping(address => Bug[]) private bugs;

  address[] public maListeUtilisateur; 
  mapping(address => Organisation[]) private maListeOrg;  
  mapping(address => Project[]) private maListeProject; 



  event UserSignedUp(address indexed userAddress, User indexed user);
  event OrgSignedUp(address indexed ownerAddress, Organisation indexed org);
  event NewProject(address indexed ownerAddress, Project indexed project); 



  //Récupérer l'utilisateur
  function user(address _address) public view returns (User memory) {
    return users[_address];
  }

  //Récupérer l'organisation
  function org(address _address) public view returns (Organisation memory) {
    return orgs[_address];
  }
 //Récupérer le projet
  function project(address _address) public view returns (Project[] memory){
    return projects[_address];
  }

 //Récupérer le beug
  function bug(address _address) public view returns (Bug[] memory){
    return bugs[_address];
  }

 //Récupérer ma liste d'utilisateurs
  function getMaListeUtilisateur() external view returns (address[] memory) {
    return maListeUtilisateur;
  }

  //Récupérer ma liste d'organisations
  function getMaListeOrg(address _address) public view returns (Organisation[] memory){
    return maListeOrg[_address];
  }

  //Récupérer ma liste de projets
  function getMaListeProject(address _address) public view returns (Project[] memory){
    return maListeProject[_address];
  }



  function signUp(string memory _name, uint256 _balance) public returns (User memory) {
    require(bytes(_name).length > 0, "username vide");
    require(!ContainsElm(maListeUtilisateur, msg.sender), "username existe deja");
    users[msg.sender] = User(_name, _balance, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    maListeUtilisateur.push(msg.sender);
    return users[msg.sender];
  }

  function orgSignUp(string memory _name, address _owner, address[] memory _members, uint256 _balance) public returns (Organisation memory) {
    require(users[msg.sender].registered, "utilisateur introuvable");
    require(bytes(_name).length > 0, "nom de l'organisation est vide");
    require(users[msg.sender].balance >= _balance, "pas assez d'argent dans le compte");
    orgs[msg.sender] = Organisation(_name, _owner, _members, _balance);
    emit OrgSignedUp(msg.sender, orgs[msg.sender]);
    users[msg.sender].balance = users[msg.sender].balance - _balance;
    return orgs[msg.sender];
  }

  

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered, "utilisateur introuvable");
    users[msg.sender].balance += amount;
    return true;
  }

  //Vérifier si maListe contiens un element spécifique 
  function ContainsElm(address[] memory l, address add) private returns(bool){ 
      bool b = false;
      for (uint i=0; i<l.length; i++) {
          if(l[i] == add){b = true;}  
      }
      return b;
    }
  // ajouter un membre a notre entreprise 
  function addMember(address _member) public{
    require(users[msg.sender].registered, "utilisateur introuvable");
    require(users[_member].registered, "membre  introuvable");
    require(!ContainsElm(orgs[msg.sender].members, _member), "membre existe deja");
    orgs[msg.sender].members.push(_member);
    maListeOrg[_member].push(orgs[msg.sender]);
  }

  // ajouter un projet 
  function addProject(string memory _name, address _owner, address[] memory _contributors, uint256 _balance) public returns (Project memory) {
      require(users[msg.sender].registered, "utilisateur introuvable");
      require(bytes(_name).length > 0, "Nom du projet est vide");
      require(users[msg.sender].balance >= _balance, "pas assez d'argent dans le compte");
      Project memory p = Project(_name, _owner, _contributors, _balance);
      projects[msg.sender].push(p);
      emit NewProject(msg.sender, p);
      users[msg.sender].balance = users[msg.sender].balance - _balance;
      return p;
    }

  // ajouter un contributors dans notre projet
  function addContributeur(address _member, uint256 _idx) public{
    require(users[msg.sender].registered, "utilisateur introuvable");
    require(users[_member].registered, "membre  introuvable");
    require(!ContainsElm(projects[msg.sender][_idx].contributors, _member), "contributeur existe deja");
    projects[msg.sender][_idx].contributors.push(_member);
    maListeProject[_member].push(projects[msg.sender][_idx]);
  }

  //l'envoi de l'argent du projet aux contributors
  function sendMoneyProject(address _owner, uint256 _idx, uint256 _amount) public{ 
    require(users[msg.sender].registered, "utilisateur introuvable");
    require(users[msg.sender].balance >= _amount, "pas assez d'argent dans le compte");
    projects[_owner][_idx].balance += _amount;
    users[msg.sender].balance = users[msg.sender].balance - _amount;
  }


  //ajout d'un beug a notre projet
  //cette partie des bugs a était tester sur un éditeur spécial pour les tests units eutheruim
  //par contre on n'a pas eu le temps de faire un front avec des transaction
  function addBug(string memory _BUG_title, string memory _BUG_description, uint256 _prize, uint256 _bugid) public{
    require(users[msg.sender].registered, "utilisateur introuvable");
    require(users[msg.sender].balance >= _prize, "pas assez d'argent dans le compte");
    string[] memory proposition;
    address[] memory proposers;
    string memory fix;
    bool  suspending = false;
    bool resolved = false;
    Bug memory bug = Bug(_BUG_title, _BUG_description, _prize, proposition, proposers, fix, suspending, resolved, _bugid);
    bugs[msg.sender].push(bug); 
    users[msg.sender].balance = users[msg.sender].balance - _prize; 
  }

  // une proposition pour un beug  "non-vérifier"
  function proposition(address _owner, uint256 _idx, string memory _fix) public{ 
    bugs[msg.sender][_idx].proposition.push(_fix); 
    bugs[msg.sender][_idx].proposers.push(msg.sender); 
    bugs[msg.sender][_idx].suspending = true;
  }

  // trouver l'index du beug 
  function trouverIndex(address[] memory l, address add) private returns(uint256){
    uint256 p = 0;
    for (uint i=0; i<l.length; i++) {
        if(l[i] == add){p = i;}  
    }
    return p;
  }

  // proposition accepté "résoulution du beug"
  function accepteProposition(uint256 _idx, address _proposer) public{
    bugs[msg.sender][_idx].resolved = true; 
    bugs[msg.sender][_idx].fix = bugs[msg.sender][_idx].proposition[trouverIndex(bugs[msg.sender][_idx].proposers, _proposer)];
    users[_proposer].balance += bugs[msg.sender][_idx].prize;
  }

   // une nouvelle adresse
   function getUniqueId() public view returns (address) 
    {

        bytes20 b = bytes20(keccak256(abi.encodePacked(msg.sender, now)));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }

        return address(addr);
    }

}