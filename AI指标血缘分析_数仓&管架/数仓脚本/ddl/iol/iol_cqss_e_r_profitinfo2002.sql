/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_profitinfo2002
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_profitinfo2002
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_profitinfo2002 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_profitinfo2002(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,mainbsn_incm number(38,0) -- 主营业务收入:eg03bj01
    ,exprt_pd_sale_incm number(38,0) -- （主营业务收入科目下）出口产品销售收入:eg03bj02
    ,impr_pd_sale_incm number(38,0) -- （主营业务收入科目下）进口产品销售收入:eg03bj03
    ,sale_dcn_with_dct number(38,0) -- 销售折扣与折让:eg03bj04
    ,mainbsn_incm_netamt number(38,0) -- 主营业务收入净额:eg03bj05
    ,mainbsn_cost number(38,0) -- 主营业务成本:eg03bj06
    ,exprt_pd_sale_cost number(38,0) -- （主营业务成本科目下）出口产品销售成本:eg03bj07
    ,mainbsn_tax_and_apd number(38,0) -- 主营业务税金及附加:eg03bj08
    ,oprt_eps number(38,0) -- 经营费用:eg03bj09
    ,othr_bcs number(38,0) -- 其他（业务成本）:eg03bj10
    ,dfr_pft number(38,0) -- 递延收益:eg03bj11
    ,prch_agnt_incm number(38,0) -- 代购代销收入:eg03bj12
    ,oicm number(38,0) -- 其他（收入）:eg03bj13
    ,mainbsn_pft number(38,0) -- 主营业务利润:eg03bj14
    ,othr_bsn_pft number(38,0) -- 其他业务利润:eg03bj15
    ,oprg_eps number(38,0) -- 营业费用:eg03bj16
    ,mtex number(38,0) -- 管理费用:eg03bj17
    ,fncex number(38,0) -- 财务费用:eg03bj18
    ,orexp number(38,0) -- 其他（费用）:eg03bj19
    ,oprg_pft number(38,0) -- 营业利润:eg03bj20
    ,ispt number(38,0) -- 投资收益:eg03bj21
    ,ftrs_pft number(38,0) -- 期货收益:eg03bj22
    ,alwc_incm number(38,0) -- 补贴收入:eg03bj23
    ,alwc_bfr_ls_entp_incm number(38,0) -- （补贴收入科目下）补贴前亏损的企业补贴收入:eg03bj24
    ,nonoprgincm number(38,0) -- 营业外收入:eg03bj25
    ,displ_fix_ast_netincm number(38,0) -- （营业外收入科目下）处置固定资产净收益:eg03bj26
    ,non_mntr_txn_pft number(38,0) -- （营业外收入科目下）非货币性交易收益:eg03bj27
    ,sell_intgbl_ast_pft number(38,0) -- （营业外收入科目下）出售无形资产收益:eg03bj28
    ,fine_net_incm number(38,0) -- （营业外收入科目下）罚款净收入:eg03bj29
    ,othr_pft number(38,0) -- 其他（利润）:eg03bj30
    ,use_bfr_ys_sal_mkpft number(38,0) -- （其他科目下）用以前年度含量工资节余弥补利润:eg03bj31
    ,nopex number(38,0) -- 营业外支出:eg03bj32
    ,displ_fix_ast_netls number(38,0) -- （营业外支出科目下）处置固定资产净损失:eg03bj33
    ,dbt_regrp_loss number(38,0) -- （营业外支出科目下）债务重组损失:eg03bj34
    ,fine_expn number(38,0) -- （营业外支出科目下）罚款支出:eg03bj35
    ,dntn_expn number(38,0) -- （营业外支出科目下）捐赠支出:eg03bj36
    ,othexp number(38,0) -- 其他支出:eg03bj37
    ,crrov_icl_num_wage_bag number(38,0) -- （其他支出）结转的含量工资包干节余:eg03bj38
    ,pft_tamt number(38,0) -- 利润总额:eg03bj39
    ,incmtax number(38,0) -- 所得税:eg03bj40
    ,less_shrh_pftandloss number(38,0) -- 少数股东损益:eg03bj41
    ,not_cfm_ivs_loss number(38,0) -- 未确认的投资损失:eg03bj42
    ,net_pft number(38,0) -- 净利润:eg03bj43
    ,begofyr_uspt number(38,0) -- 年初未分配利润:eg03bj44
    ,splrsv_recloss number(38,0) -- 盈余公积补亏:eg03bj45
    ,othr_adj_fctr number(38,0) -- 其他调整因素:eg03bj46
    ,dstr_pft number(38,0) -- 可供分配的利润:eg03bj47
    ,idv_use_pft number(38,0) -- 单项留用的利润:eg03bj48
    ,splmt_lqud_cptl number(38,0) -- 补充流动资本:eg03bj49
    ,rtrv_lgl_splrsv number(38,0) -- 提取法定盈余公积:eg03bj50
    ,rtrv_lgl_pbwlf_gld number(38,0) -- 提取法定公益金:eg03bj51
    ,exta_wk_rwd_wlf_fnd number(38,0) -- 提取职工奖励及福利基金:eg03bj52
    ,rtrv_rsrv_fnd number(38,0) -- 提取储备基金:eg03bj53
    ,rtrv_entp_dvlp_fnd number(38,0) -- 提取企业发展基金:eg03bj54
    ,pft_ret_ivs number(38,0) -- 利润归还投资:eg03bj55
    ,othr_dstr_pft number(38,0) -- （可供分配的利润科目下）其他:eg03bj56
    ,avl_ivsr_alct_pft number(38,0) -- 可供投资者分配的利润:eg03bj57
    ,pbl_prshr_dvdn number(38,0) -- 应付优先股股利:eg03bj58
    ,rtrv_rndm_splrsv number(38,0) -- 提取任意盈余公积:eg03bj59
    ,pbl_ord_shr_dvdn number(38,0) -- 应付普通股股利:eg03bj60
    ,tfr_mk_cptl_ord_shr_dvdn number(38,0) -- 转作资本的普通股股利:eg03bj61
    ,othr_avl_ivsr_alct_pft number(38,0) -- （可供投资者分配的利润科目下）其他:eg03bj62
    ,uspt number(38,0) -- 未分配利润:eg03bj63
    ,afr_anul_tax_bfr_pft_rmnls number(38,0) -- （未分配利润科目下）应由以后年度税前利润弥补的亏损:eg03bj64
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_profitinfo2002 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2002 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2002 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2002 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_profitinfo2002 is '企业利润及利润分配表（2002 版）信息表';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mainbsn_incm is '主营业务收入:eg03bj01';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.exprt_pd_sale_incm is '（主营业务收入科目下）出口产品销售收入:eg03bj02';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.impr_pd_sale_incm is '（主营业务收入科目下）进口产品销售收入:eg03bj03';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.sale_dcn_with_dct is '销售折扣与折让:eg03bj04';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mainbsn_incm_netamt is '主营业务收入净额:eg03bj05';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mainbsn_cost is '主营业务成本:eg03bj06';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.exprt_pd_sale_cost is '（主营业务成本科目下）出口产品销售成本:eg03bj07';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mainbsn_tax_and_apd is '主营业务税金及附加:eg03bj08';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.oprt_eps is '经营费用:eg03bj09';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_bcs is '其他（业务成本）:eg03bj10';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.dfr_pft is '递延收益:eg03bj11';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.prch_agnt_incm is '代购代销收入:eg03bj12';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.oicm is '其他（收入）:eg03bj13';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mainbsn_pft is '主营业务利润:eg03bj14';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_bsn_pft is '其他业务利润:eg03bj15';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.oprg_eps is '营业费用:eg03bj16';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.mtex is '管理费用:eg03bj17';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.fncex is '财务费用:eg03bj18';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.orexp is '其他（费用）:eg03bj19';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.oprg_pft is '营业利润:eg03bj20';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.ispt is '投资收益:eg03bj21';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.ftrs_pft is '期货收益:eg03bj22';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.alwc_incm is '补贴收入:eg03bj23';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.alwc_bfr_ls_entp_incm is '（补贴收入科目下）补贴前亏损的企业补贴收入:eg03bj24';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.nonoprgincm is '营业外收入:eg03bj25';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.displ_fix_ast_netincm is '（营业外收入科目下）处置固定资产净收益:eg03bj26';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.non_mntr_txn_pft is '（营业外收入科目下）非货币性交易收益:eg03bj27';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.sell_intgbl_ast_pft is '（营业外收入科目下）出售无形资产收益:eg03bj28';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.fine_net_incm is '（营业外收入科目下）罚款净收入:eg03bj29';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_pft is '其他（利润）:eg03bj30';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.use_bfr_ys_sal_mkpft is '（其他科目下）用以前年度含量工资节余弥补利润:eg03bj31';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.nopex is '营业外支出:eg03bj32';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.displ_fix_ast_netls is '（营业外支出科目下）处置固定资产净损失:eg03bj33';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.dbt_regrp_loss is '（营业外支出科目下）债务重组损失:eg03bj34';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.fine_expn is '（营业外支出科目下）罚款支出:eg03bj35';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.dntn_expn is '（营业外支出科目下）捐赠支出:eg03bj36';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othexp is '其他支出:eg03bj37';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.crrov_icl_num_wage_bag is '（其他支出）结转的含量工资包干节余:eg03bj38';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.pft_tamt is '利润总额:eg03bj39';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.incmtax is '所得税:eg03bj40';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.less_shrh_pftandloss is '少数股东损益:eg03bj41';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.not_cfm_ivs_loss is '未确认的投资损失:eg03bj42';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.net_pft is '净利润:eg03bj43';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.begofyr_uspt is '年初未分配利润:eg03bj44';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.splrsv_recloss is '盈余公积补亏:eg03bj45';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_adj_fctr is '其他调整因素:eg03bj46';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.dstr_pft is '可供分配的利润:eg03bj47';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.idv_use_pft is '单项留用的利润:eg03bj48';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.splmt_lqud_cptl is '补充流动资本:eg03bj49';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.rtrv_lgl_splrsv is '提取法定盈余公积:eg03bj50';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.rtrv_lgl_pbwlf_gld is '提取法定公益金:eg03bj51';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.exta_wk_rwd_wlf_fnd is '提取职工奖励及福利基金:eg03bj52';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.rtrv_rsrv_fnd is '提取储备基金:eg03bj53';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.rtrv_entp_dvlp_fnd is '提取企业发展基金:eg03bj54';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.pft_ret_ivs is '利润归还投资:eg03bj55';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_dstr_pft is '（可供分配的利润科目下）其他:eg03bj56';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.avl_ivsr_alct_pft is '可供投资者分配的利润:eg03bj57';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.pbl_prshr_dvdn is '应付优先股股利:eg03bj58';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.rtrv_rndm_splrsv is '提取任意盈余公积:eg03bj59';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.pbl_ord_shr_dvdn is '应付普通股股利:eg03bj60';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.tfr_mk_cptl_ord_shr_dvdn is '转作资本的普通股股利:eg03bj61';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.othr_avl_ivsr_alct_pft is '（可供投资者分配的利润科目下）其他:eg03bj62';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.uspt is '未分配利润:eg03bj63';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.afr_anul_tax_bfr_pft_rmnls is '（未分配利润科目下）应由以后年度税前利润弥补的亏损:eg03bj64';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_profitinfo2002.etl_timestamp is 'ETL处理时间戳';
