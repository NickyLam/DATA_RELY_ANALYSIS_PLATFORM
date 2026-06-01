/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_comb_prod_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_comb_prod_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_comb_prod_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_comb_prod_info_h(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,comb_prod_name varchar2(750) -- 组合产品名称
    ,status_cd varchar2(30) -- 状态代码
    ,prod_risk_level_cd varchar2(30) -- 产品风险等级代码
    ,tran_chn_cd varchar2(60) -- 交易渠道代码
    ,tran_mode varchar2(15) -- 交易模式
    ,fin_mode_cd varchar2(30) -- 财务模式代码
    ,open_tm varchar2(60) -- 开市时间
    ,close_tm varchar2(60) -- 闭市时间
    ,sevn_aual_yld number(18,8) -- 七日年化收益率
    ,ten_thous_prft number(22,12) -- 万份收益
    ,indv_lowt_aip_amt number(30,2) -- 个人最低定投金额
    ,amax_bamt number(30,2) -- 累计最大购买金额
    ,acm_max_redem_amt number(30,2) -- 累计最大赎回金额
    ,supp_invest_amt number(30,2) -- 追加投资金额
    ,create_tm timestamp -- 创建时间
    ,final_modif_tm timestamp -- 最后修改时间
    ,remark varchar2(1500) -- 备注
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
grant select on ${iml_schema}.prd_comb_prod_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_comb_prod_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_comb_prod_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_comb_prod_info_h is '组合产品信息历史';
comment on column ${iml_schema}.prd_comb_prod_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_comb_prod_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_comb_prod_info_h.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.prd_comb_prod_info_h.comb_prod_name is '组合产品名称';
comment on column ${iml_schema}.prd_comb_prod_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.prd_comb_prod_info_h.prod_risk_level_cd is '产品风险等级代码';
comment on column ${iml_schema}.prd_comb_prod_info_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.prd_comb_prod_info_h.tran_mode is '交易模式';
comment on column ${iml_schema}.prd_comb_prod_info_h.fin_mode_cd is '财务模式代码';
comment on column ${iml_schema}.prd_comb_prod_info_h.open_tm is '开市时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.close_tm is '闭市时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_comb_prod_info_h.ten_thous_prft is '万份收益';
comment on column ${iml_schema}.prd_comb_prod_info_h.indv_lowt_aip_amt is '个人最低定投金额';
comment on column ${iml_schema}.prd_comb_prod_info_h.amax_bamt is '累计最大购买金额';
comment on column ${iml_schema}.prd_comb_prod_info_h.acm_max_redem_amt is '累计最大赎回金额';
comment on column ${iml_schema}.prd_comb_prod_info_h.supp_invest_amt is '追加投资金额';
comment on column ${iml_schema}.prd_comb_prod_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.remark is '备注';
comment on column ${iml_schema}.prd_comb_prod_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_comb_prod_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_comb_prod_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_comb_prod_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_comb_prod_info_h.etl_timestamp is 'ETL处理时间戳';
