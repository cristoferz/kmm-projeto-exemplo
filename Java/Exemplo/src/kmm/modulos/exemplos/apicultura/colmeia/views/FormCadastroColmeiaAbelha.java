package kmm.modulos.exemplos.apicultura.colmeia.views;

import kmm.lib.collection.ParameterMap;
import kmm.lib.connection.KMMConnectionManager;
import kmm.lib.database.columns.ColumnString;
import kmm.lib.database.columns.KMMColumnModel;
import kmm.lib.database.controls.KMMDataSetAbstract;
import kmm.lib.database.controls.KMMDatasetParameterMap;
import kmm.padroes.cadastro.filho.CadastroFilhoPadrao;

/**
 *
 * @author cristofer
 */
public class FormCadastroColmeiaAbelha extends CadastroFilhoPadrao {
   
   private KMMDatasetParameterMap datasetModalidades;

   public FormCadastroColmeiaAbelha(KMMConnectionManager manager, KMMDataSetAbstract dataset) throws Exception {
      super(manager);
      initComponents();
      setDataset(dataset);
      configTela();
   }

   @Override
   public String getTitle() {
      return "Apicultura - Cadastro de abelhas da colméia";
   }

   private void configTela() throws Exception {
      preencheComboBox();
      configDataset();
   }
   
   private void preencheComboBox() throws Exception {
      
   }
   
   private void configDataset() throws Exception {
      jExtNumberFieldNumAbelha.setDataSet(getDataset(), "num_abelha");
      jExtTextFieldNome.setDataSet(getDataset(), "nome");
      jExtNumberFieldProducaoIndividual.setDataSet(getDataset(), "producao_individual");
      jExtComboBoxModalidade.setDataset(getDataset(), "modalidade");
      
      datasetModalidades = new KMMDatasetParameterMap(new KMMColumnModel(
              new ColumnString("cod_modalidade", "Cód. modalidade", false, true),
              new ColumnString("descricao", "Descrição", false, true)
      ));
      jExtComboBoxModalidade.setListDataset(datasetModalidades, "cod_modalidade", "descricao");
   }

   @Override
   public void load(ParameterMap parameterMap) throws Exception {
      if (parameterMap.hasValue("modalidades")) {
         datasetModalidades.loadData(parameterMap.getParameterList("modalidades"));
      }
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
      jExtLabelNumAbelha = new kmm.componentes.controle.label.JExtLabel();
      jExtLabelNome = new kmm.componentes.controle.label.JExtLabel();
      jExtLabelProducaoIndividual = new kmm.componentes.controle.label.JExtLabel();
      jExtLabelModalidade = new kmm.componentes.controle.label.JExtLabel();
      jExtNumberFieldProducaoIndividual = new kmm.componentes.controle.numberfield.JExtNumberField();
      jExtComboBoxModalidade = new kmm.componentes.controle.combobox.JExtComboBox();
      jExtTextFieldNome = new kmm.componentes.controle.textfield.JExtTextField();
      jExtNumberFieldNumAbelha = new kmm.componentes.controle.numberfield.JExtNumberField();
      jExtLabelProducaoIndividualUnidade = new kmm.componentes.controle.label.JExtLabel();

      jPanelPrincipal.setBorder(javax.swing.BorderFactory.createTitledBorder(""));

      jExtLabelNumAbelha.setText("Número:");

      jExtLabelNome.setText("Nome:");

      jExtLabelProducaoIndividual.setText("Produção individual:");

      jExtLabelModalidade.setText("Modalidade:");

      jExtNumberFieldProducaoIndividual.setText("jExtNumberField1");

      jExtNumberFieldNumAbelha.setText("jExtNumberField2");

      jExtLabelProducaoIndividualUnidade.setText("ml/dia");

      javax.swing.GroupLayout jPanelPrincipalLayout = new javax.swing.GroupLayout(jPanelPrincipal);
      jPanelPrincipal.setLayout(jPanelPrincipalLayout);
      jPanelPrincipalLayout.setHorizontalGroup(
         jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(jPanelPrincipalLayout.createSequentialGroup()
            .addContainerGap()
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
               .addComponent(jExtLabelProducaoIndividual, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelModalidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelNome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelNumAbelha, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
               .addComponent(jExtTextFieldNome, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
               .addGroup(jPanelPrincipalLayout.createSequentialGroup()
                  .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                     .addComponent(jExtComboBoxModalidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                     .addComponent(jExtNumberFieldNumAbelha, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                     .addGroup(jPanelPrincipalLayout.createSequentialGroup()
                        .addComponent(jExtNumberFieldProducaoIndividual, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jExtLabelProducaoIndividualUnidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                  .addGap(0, 274, Short.MAX_VALUE)))
            .addContainerGap())
      );
      jPanelPrincipalLayout.setVerticalGroup(
         jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(jPanelPrincipalLayout.createSequentialGroup()
            .addContainerGap()
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelNumAbelha, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtNumberFieldNumAbelha, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelNome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtTextFieldNome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelProducaoIndividual, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtNumberFieldProducaoIndividual, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtLabelProducaoIndividualUnidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanelPrincipalLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(jExtLabelModalidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
               .addComponent(jExtComboBoxModalidade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addContainerGap(15, Short.MAX_VALUE))
      );

      javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getPanelConteudo());
      getPanelConteudo().setLayout(layout);
      layout.setHorizontalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(layout.createSequentialGroup()
            .addContainerGap()
            .addComponent(jPanelPrincipal, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addContainerGap())
      );
      layout.setVerticalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(layout.createSequentialGroup()
            .addContainerGap()
            .addComponent(jPanelPrincipal, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
      );
   }// </editor-fold>//GEN-END:initComponents
   // Variables declaration - do not modify//GEN-BEGIN:variables
   private kmm.componentes.controle.combobox.JExtComboBox jExtComboBoxModalidade;
   private kmm.componentes.controle.label.JExtLabel jExtLabelModalidade;
   private kmm.componentes.controle.label.JExtLabel jExtLabelNome;
   private kmm.componentes.controle.label.JExtLabel jExtLabelNumAbelha;
   private kmm.componentes.controle.label.JExtLabel jExtLabelProducaoIndividual;
   private kmm.componentes.controle.label.JExtLabel jExtLabelProducaoIndividualUnidade;
   private kmm.componentes.controle.numberfield.JExtNumberField jExtNumberFieldNumAbelha;
   private kmm.componentes.controle.numberfield.JExtNumberField jExtNumberFieldProducaoIndividual;
   private kmm.componentes.controle.textfield.JExtTextField jExtTextFieldNome;
   private javax.swing.JPanel jPanelPrincipal;
   // End of variables declaration//GEN-END:variables
}
