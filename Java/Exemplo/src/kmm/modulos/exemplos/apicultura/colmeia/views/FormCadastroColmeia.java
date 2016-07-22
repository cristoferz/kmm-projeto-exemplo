package kmm.modulos.exemplos.apicultura.colmeia.views;

import kmm.componentes.container.BaseContainer;
import kmm.componentes.controle.searchfield.SearchFieldConfig;
import kmm.componentes.windows.WindowController;
import kmm.lib.collection.ParameterList;
import kmm.lib.collection.ParameterMap;
import kmm.lib.collection.WindowParameters;
import kmm.lib.connection.KMMConnectionManager;
import kmm.lib.database.columns.ColumnInteger;
import kmm.lib.database.columns.ColumnString;
import kmm.lib.database.columns.KMMColumnModel;
import kmm.lib.database.controls.KMMDataSetAbstract;
import kmm.lib.database.controls.KMMDataSetRow;
import kmm.lib.database.controls.KMMDatasetParameterMap;
import kmm.lib.database.controls.ParameterListRefresher;
import kmm.modulos.exemplos.apicultura.colmeia.lists.FormListaColmeia;
import kmm.padroes.cadastro.CadastroPadrao;
import kmm.padroes.localizar.LocalizarFilter;
import kmm.padroes.localizar.LocalizarFilters;
import kmm.padroes.localizar.LocalizarPadrao;

/**
 *
 * @author cristofer
 */
public class FormCadastroColmeia extends CadastroPadrao {

   private KMMDatasetParameterMap datasetAbelhas, datasetEspecie;

   private FormCadastroColmeiaAbelha formCadastroColmeiaAbelha;

   public FormCadastroColmeia(KMMConnectionManager manager, WindowParameters parameters) throws Exception {
      super(manager, parameters);
      initComponents();
      configTela();

   }

   public static BaseContainer createFormCadastroColmeia(KMMConnectionManager manager, WindowParameters parameters) throws Exception {
      return new FormCadastroColmeia(manager, parameters);
   }

   @Override
   public String getTitle() {
      return "Exemplo - Cadastro de Colméia";
   }

   @Override
   public String[] getLocalizarFieldList() {
      return new String[]{"colmeia_id"};
   }

   @Override
   protected int getType() {
      return TYPE_BACKEND;
   }

   @Override
   public String getCodModule() {
      return "EXEMPLO";
   }

   @Override
   protected ParameterMap rowToParameterMap(KMMDataSetRow row) throws Exception {
      ParameterMap arguments = super.rowToParameterMap(row);
      // Removendo campos desnecessários
      arguments.remove("cod_ibge");
      arguments.remove("municipio");
      arguments.remove("uf");
      return arguments;
   }

   @Override
   protected KMMDataSetAbstract createDataset() {
      return new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnInteger("colmeia_id", "ID colmeia", true, true),
              new ColumnInteger("num_colmeia", "Número", false, true),
              new ColumnString("descricao", "Descrição", false, true),
              new ColumnString("tipo", "Tipo", false, true),
              new ColumnInteger("producao_minima", "Produção mínima", false, true),
              new ColumnInteger("municipio_id", "ID município", true, true),
              new ColumnString("cod_ibge", "Cód. IBGE", false, true),
              new ColumnString("municipio", "Município", false, true),
              new ColumnString("uf", "UF", false, true)
      ), new ParameterListRefresher() {
         @Override
         public ParameterList refresh(ParameterMap parameters) throws Exception {
            if (parameters.hasValue("colmeia_id")) {
               parameters.put("retornar_abelhas", true);
               ParameterMap result = backendCall(getCodModule(), "getColmeia", parameters);
               if (result.hasValue("colmeias")) {
                  return result.getParameterList("colmeias");
               } else {
                  throw new Exception("Não foi encontrada a variavel \"colmeias\" no retorno");
               }
            } else {
               return new ParameterList();
            }
         }
      });
   }

   @Override
   protected LocalizarPadrao createLocalizar() throws Exception {
      return new LocalizarPadrao(this, "Localizar", new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnInteger("colmeia_id", "ID colmeia", false, true),
              new ColumnInteger("num_colmeia", "Número", false, true),
              new ColumnString("descricao", "Descrição", false, true),
              new ColumnString("tipo", "Tipo", false, true),
              new ColumnString("municipio", "Município", false, true),
              new ColumnString("uf", "UF", false, true)
      ), new ParameterListRefresher() {
         @Override
         public ParameterList refresh(ParameterMap parameters) throws Exception {
            ParameterMap result = backendCall("EXEMPLO", "getColmeia", parameters);
            if (result.hasValue("colmeias")) {
               return result.getParameterList("colmeias");
            } else {
               throw new Exception("Não foi encontrada a variavel \"colmeias\" no retorno "+result.toString(3));
            }

         }
      }), new LocalizarFilters(
              new LocalizarFilter("Número", "num_colmeia", LocalizarFilter.NUMBER),
              new LocalizarFilter("Descrição", "descricao", LocalizarFilter.STRING),
              new LocalizarFilter("Município", "municipio", LocalizarFilter.STRING)
      ));
   }

   @Override
   protected void onLista() throws Exception {
      WindowController.openWindow(new FormListaColmeia(getManager(), this), WindowController.NEW_FRAME);
   }

   private void configTela() throws Exception {
      preencheComboBox();
      configDataset();
   }

   private void preencheComboBox() throws Exception {

   }

   private void configDataset() throws Exception {
      // Definindo operações de manipulação
      setInsertFunction("insColmeia");
      setUpdateFunction("updColmeia");
      setDeleteFunction("delColmeia");

      getDataset().setRequiredFields(new String[]{
         "num_colmeia", "descricao", "tipo", "municipio_id", "cod_ibge"
      });

      // Vinculando campos ao dataset
      jExtTextFieldNumColmeia.setDataSet(getDataset(), "num_colmeia");
      jExtTextFieldDescricao.setDataSet(getDataset(), "descricao");
      jExtComboBoxTipo.setDataset(getDataset(), "tipo");
      jExtNumberFieldProducaoMinima.setDataSet(getDataset(), "producao_minima");
      jSearchFieldCodIbge.setDataSet(getDataset(), "cod_ibge");
      jExtTextFieldMunicipio.setDataSet(getDataset(), "municipio");
      jExtTextFieldMunicipioUf.setDataSet(getDataset(), "uf");

      datasetEspecie = new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnString("cod_especie", "Cód. especie", false, true),
              new ColumnString("descricao", "Descrição", false, true)
      ));
      jExtComboBoxTipo.setListDataset(datasetEspecie, "cod_especie", "descricao");

      // Configurando o searchField
      ParameterListRefresher refresher = new ParameterListRefresher() {
         @Override
         public ParameterList refresh(ParameterMap pm) throws Exception {
            ParameterMap result = backendCall(getCodModule(), "getMunicipio", pm);
            if (result.hasValue("municipios")) {
               return result.getParameterList("municipios");
            } else {
               throw new Exception("Não foi retornada a tag \"municipios\" do backend");
            }
         }
      };
      
      SearchFieldConfig searchFieldConfig = new SearchFieldConfig();
      searchFieldConfig.setBaseContainer(this);
      searchFieldConfig.setLocalizarPadrao(new LocalizarPadrao(this, "Localizar município", new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnInteger("municipio_id", "ID municipio", true, true),
              new ColumnString("cod_ibge", "Cód. IBGE", false, true),
              new ColumnString("municipio", "Município", false, true),
              new ColumnString("uf", "UF", false, true)
      ), refresher), new LocalizarFilters(
              new LocalizarFilter("Município", "municipio", LocalizarFilter.STRING),
              new LocalizarFilter("Cód. IBGE", "cod_ibge", LocalizarFilter.STRING)
      )));
      searchFieldConfig.setFocusLostFieldName("cod_ibge");
      searchFieldConfig.setRefresher(refresher);
      searchFieldConfig.setMapping(new String[]{"cod_ibge", "cod_ibge", "municipio", "municipio", "municipio_id", "municipio_id", "uf", "uf"});
      jSearchFieldCodIbge.configSearchField(searchFieldConfig);

      // Criando o datasetFilho
      datasetAbelhas = new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnInteger("abelha_id", "ID abelha", true, true),
              new ColumnInteger("num_abelha", "Número", false, true),
              new ColumnString("nome", "Nome", false, true),
              new ColumnInteger("producao_individual", "Produção individual", false, true),
              new ColumnString("modalidade", "Modalidade", false, true)
      ));
      datasetAbelhas.open();
      jGridAbelhas.setDataSet(datasetAbelhas);
      jDataSetControlAbelhas.setMasterDataSet(getDataset(), "abelhas");
      jDataSetControlAbelhas.setDataset(datasetAbelhas);
      jGridAbelhas.applyColumnBestFit();

      // Criando o Cadastro Filho
      formCadastroColmeiaAbelha = new FormCadastroColmeiaAbelha(getManager(), datasetAbelhas);
      formCadastroColmeiaAbelha.setDatasetControl(jDataSetControlAbelhas);
      formCadastroColmeiaAbelha.setGrid(jGridAbelhas);

      initData();
   }

   private void initData() throws Exception {
      // Carregando dados iniciais
      ParameterMap args = new ParameterMap();
      args.put("retornar_especies", true);
      args.put("retornar_modalidades", true);
      ParameterMap dadosIniciais = backendCall(getCodModule(), "initColmeia", args);
      if (dadosIniciais.hasValue("especies")) {
         datasetEspecie.loadData(dadosIniciais.getParameterList("especies"));
      }

      // Carregando dados da tela de cadastro filho
      formCadastroColmeiaAbelha.load(dadosIniciais);
   }

   /**
    * This method is called from within the constructor to initialize the form.
    * WARNING: Do NOT modify this code. The content of this method is always
    * regenerated by the Form Editor.
    */
   @SuppressWarnings("unchecked")
   // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
   private void initComponents() {

      jPanelPrincipal = new javax.swing.JPanel();
      jExtLabelNumColmeia = new kmm.componentes.controle.label.JExtLabel();
      jExtTextFieldNumColmeia = new kmm.componentes.controle.textfield.JExtTextField();
      jExtLabelDescricao = new kmm.componentes.controle.label.JExtLabel();
      jExtTextFieldDescricao = new kmm.componentes.controle.textfield.JExtTextField();
      jExtLabelTipo = new kmm.componentes.controle.label.JExtLabel();
      jExtComboBoxTipo = new kmm.componentes.controle.combobox.JExtComboBox();
      jExtNumberFieldProducaoMinima = new kmm.componentes.controle.numberfield.JExtNumberField();
      jSearchFieldCodIbge = new kmm.componentes.controle.searchfield.JSearchField();
      jExtTextFieldMunicipio = new kmm.componentes.controle.textfield.JExtTextField();
      jExtLabelProducaoMinima = new kmm.componentes.controle.label.JExtLabel();
      jExtLabelMunicipio = new kmm.componentes.controle.label.JExtLabel();
      jExtLabelProducaoMinimaUnidade = new kmm.componentes.controle.label.JExtLabel();
      jExtTextFieldMunicipioUf = new kmm.componentes.controle.textfield.JExtTextField();
      jPanel1 = new javax.swing.JPanel();
      jDataSetControlAbelhas = new kmm.componentes.controle.datasetcontrol.JDataSetControl();
      jGridAbelhas = new kmm.componentes.jgrid.JGrid();

      getPanelConteudo().setLayout(new java.awt.BorderLayout());

      jPanelPrincipal.setBorder(javax.swing.BorderFactory.createTitledBorder(""));

      jExtLabelNumColmeia.setText("Número:");

      jExtLabelDescricao.setText("Descrição:");

      jExtLabelTipo.setText("Tipo:");

      jExtNumberFieldProducaoMinima.setText("jExtNumberField1");

      jExtTextFieldMunicipio.setEditable(false);

      jExtLabelProducaoMinima.setText("Produção mínima:");

      jExtLabelMunicipio.setText("Município:");

      jExtLabelProducaoMinimaUnidade.setText("ml/dia");

      jExtTextFieldMunicipioUf.setEditable(false);

      javax.swing.GroupLayout jPanelPrincipalLayout = new javax.swing.GroupLayout(jPanelPrincipal);
      jPanelPrincipal.setLayout(jPanelPrincipalLayout);
      jPanelPrincipalLayout.setHorizontalGroup(
         jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(jPanelPrincipalLayout.createSequentialGroup()
            .addContainerGap()
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
               .addComponent(jExtLabelNumColmeia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelDescricao, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelTipo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelProducaoMinima, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelMunicipio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
               .addComponent(jExtTextFieldDescricao, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
               .addGroup(jPanelPrincipalLayout.createSequentialGroup()
                  .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                     .addGroup(jPanelPrincipalLayout.createSequentialGroup()
                        .addComponent(jExtNumberFieldProducaoMinima, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jExtLabelProducaoMinimaUnidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                     .addComponent(jExtComboBoxTipo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                     .addComponent(jExtTextFieldNumColmeia, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                  .addGap(0, 0, Short.MAX_VALUE))
               .addGroup(jPanelPrincipalLayout.createSequentialGroup()
                  .addComponent(jSearchFieldCodIbge, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(jExtTextFieldMunicipio, javax.swing.GroupLayout.DEFAULT_SIZE, 203, Short.MAX_VALUE)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(jExtTextFieldMunicipioUf, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))
            .addContainerGap())
      );
      jPanelPrincipalLayout.setVerticalGroup(
         jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(jPanelPrincipalLayout.createSequentialGroup()
            .addContainerGap()
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelNumColmeia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtTextFieldNumColmeia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtTextFieldDescricao, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelDescricao, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelTipo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtComboBoxTipo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtNumberFieldProducaoMinima, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelProducaoMinima, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelProducaoMinimaUnidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jSearchFieldCodIbge, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtTextFieldMunicipio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelMunicipio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtTextFieldMunicipioUf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
      );

      getPanelConteudo().add(jPanelPrincipal, java.awt.BorderLayout.NORTH);

      jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Abelhas:"));
      jPanel1.setLayout(new java.awt.BorderLayout());
      jPanel1.add(jDataSetControlAbelhas, java.awt.BorderLayout.PAGE_START);
      jPanel1.add(jGridAbelhas, java.awt.BorderLayout.CENTER);

      getPanelConteudo().add(jPanel1, java.awt.BorderLayout.CENTER);
   }// </editor-fold>//GEN-END:initComponents
   // Variables declaration - do not modify//GEN-BEGIN:variables
   private kmm.componentes.controle.datasetcontrol.JDataSetControl jDataSetControlAbelhas;
   private kmm.componentes.controle.combobox.JExtComboBox jExtComboBoxTipo;
   private kmm.componentes.controle.label.JExtLabel jExtLabelDescricao;
   private kmm.componentes.controle.label.JExtLabel jExtLabelMunicipio;
   private kmm.componentes.controle.label.JExtLabel jExtLabelNumColmeia;
   private kmm.componentes.controle.label.JExtLabel jExtLabelProducaoMinima;
   private kmm.componentes.controle.label.JExtLabel jExtLabelProducaoMinimaUnidade;
   private kmm.componentes.controle.label.JExtLabel jExtLabelTipo;
   private kmm.componentes.controle.numberfield.JExtNumberField jExtNumberFieldProducaoMinima;
   private kmm.componentes.controle.textfield.JExtTextField jExtTextFieldDescricao;
   private kmm.componentes.controle.textfield.JExtTextField jExtTextFieldMunicipio;
   private kmm.componentes.controle.textfield.JExtTextField jExtTextFieldMunicipioUf;
   private kmm.componentes.controle.textfield.JExtTextField jExtTextFieldNumColmeia;
   private kmm.componentes.jgrid.JGrid jGridAbelhas;
   private javax.swing.JPanel jPanel1;
   private javax.swing.JPanel jPanelPrincipal;
   private kmm.componentes.controle.searchfield.JSearchField jSearchFieldCodIbge;
   // End of variables declaration//GEN-END:variables
}
