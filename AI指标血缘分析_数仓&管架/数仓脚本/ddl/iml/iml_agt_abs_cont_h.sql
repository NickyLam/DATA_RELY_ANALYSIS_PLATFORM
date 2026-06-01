/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_abs_cont_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_abs_cont_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_abs_cont_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_cont_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,asset_bag_cont_id varchar2(100) -- 资产包合同编号
    ,curr_cd varchar2(30) -- 币种代码
    ,bus_tran_dt date -- 业务交易日期
    ,prod_id varchar2(100) -- 产品编号
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,asset_bag_id varchar2(100) -- 资产包编号
    ,asset_bag_name varchar2(500) -- 资产包名称
    ,asset_bag_amt number(30,2) -- 资产包金额
    ,asset_bag_cont_seq_num varchar2(60) -- 资产包合同序号
    ,asset_bag_cont_type_cd varchar2(30) -- 资产包合同类型代码
    ,asset_bag_cont_status_cd varchar2(30) -- 资产包合同状态代码
    ,asset_bag_tran_type_cd varchar2(30) -- 资产包转让类型代码
    ,non_asset_flg varchar2(10) -- 不良资产标志
    ,issue_tran_tm timestamp -- 发行交易时间
    ,issue_revo_dt date -- 发行撤销日期
    ,pkg_dt date -- 封包日期
    ,pkg_tran_tm timestamp -- 封包交易时间
    ,issue_convt_prem number(30,2) -- 发行折溢价
    ,comp_int_tran_out_idf_cd varchar2(30) -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd varchar2(30) -- 罚息转出标识代码
    ,int_tran_out_idf_cd varchar2(30) -- 利息转出标识代码
    ,pl_calc_way_cd varchar2(30) -- 损益计算方式代码
    ,imp_blank_draw_dt date -- 重空出票日期
    ,redem_convt_prem number(30,2) -- 赎回折溢价
    ,redem_value_dt date -- 赎回起息日期
    ,asset_redem_dt date -- 资产赎回日期
    ,revo_pkg_dt date -- 撤包日期
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_tm timestamp -- 交易时间
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,apv_teller_id varchar2(100) -- 审批柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,amorted_int number(30,2) -- 已摊销利息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_abs_cont_h to ${icl_schema};
grant select on ${iml_schema}.agt_abs_cont_h to ${idl_schema};
grant select on ${iml_schema}.agt_abs_cont_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_abs_cont_h is '资产证券化合同历史';
comment on column ${iml_schema}.agt_abs_cont_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_abs_cont_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_cont_id is '资产包合同编号';
comment on column ${iml_schema}.agt_abs_cont_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_abs_cont_h.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.agt_abs_cont_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_abs_cont_h.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_id is '资产包编号';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_name is '资产包名称';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_amt is '资产包金额';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_cont_seq_num is '资产包合同序号';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_cont_type_cd is '资产包合同类型代码';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_cont_status_cd is '资产包合同状态代码';
comment on column ${iml_schema}.agt_abs_cont_h.asset_bag_tran_type_cd is '资产包转让类型代码';
comment on column ${iml_schema}.agt_abs_cont_h.non_asset_flg is '不良资产标志';
comment on column ${iml_schema}.agt_abs_cont_h.issue_tran_tm is '发行交易时间';
comment on column ${iml_schema}.agt_abs_cont_h.issue_revo_dt is '发行撤销日期';
comment on column ${iml_schema}.agt_abs_cont_h.pkg_dt is '封包日期';
comment on column ${iml_schema}.agt_abs_cont_h.pkg_tran_tm is '封包交易时间';
comment on column ${iml_schema}.agt_abs_cont_h.issue_convt_prem is '发行折溢价';
comment on column ${iml_schema}.agt_abs_cont_h.comp_int_tran_out_idf_cd is '复利转出标识代码';
comment on column ${iml_schema}.agt_abs_cont_h.pnlt_tran_out_idf_cd is '罚息转出标识代码';
comment on column ${iml_schema}.agt_abs_cont_h.int_tran_out_idf_cd is '利息转出标识代码';
comment on column ${iml_schema}.agt_abs_cont_h.pl_calc_way_cd is '损益计算方式代码';
comment on column ${iml_schema}.agt_abs_cont_h.imp_blank_draw_dt is '重空出票日期';
comment on column ${iml_schema}.agt_abs_cont_h.redem_convt_prem is '赎回折溢价';
comment on column ${iml_schema}.agt_abs_cont_h.redem_value_dt is '赎回起息日期';
comment on column ${iml_schema}.agt_abs_cont_h.asset_redem_dt is '资产赎回日期';
comment on column ${iml_schema}.agt_abs_cont_h.revo_pkg_dt is '撤包日期';
comment on column ${iml_schema}.agt_abs_cont_h.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.agt_abs_cont_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_abs_cont_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_abs_cont_h.apv_teller_id is '审批柜员编号';
comment on column ${iml_schema}.agt_abs_cont_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_abs_cont_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_abs_cont_h.amorted_int is '已摊销利息';
comment on column ${iml_schema}.agt_abs_cont_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_abs_cont_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_abs_cont_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_abs_cont_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_abs_cont_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_abs_cont_h.etl_timestamp is 'ETL处理时间戳';
