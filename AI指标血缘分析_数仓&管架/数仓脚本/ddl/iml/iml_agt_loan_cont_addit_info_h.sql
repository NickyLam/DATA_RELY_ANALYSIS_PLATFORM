/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_addit_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_addit_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_addit_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_addit_info_h(
    agt_id varchar2(250) -- 协议编号
    ,cont_id varchar2(100) -- 合同编号
    ,asset_pool_agt_cont_id varchar2(100) -- 资产池协议合同编号
    ,nl_bus_flg varchar2(10) -- 南铝业务标志
    ,ocup_pool_water_level_amt number(30,2) -- 占用池水位金额
    ,asset_pool_agt_sign_tm timestamp -- 资产池协议签署时间
    ,curr_brwer_flg varchar2(10) -- 当前借款人标志
    ,aldy_sign_pool_fin_agt_flg varchar2(10) -- 已签订池融资协议标志
    ,asset_pool_higt_lmt_guar_cont_id varchar2(100) -- 资产池最高额担保合同编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_cont_addit_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_addit_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_addit_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_addit_info_h is '贷款合同附加信息历史';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.asset_pool_agt_cont_id is '资产池协议合同编号';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.nl_bus_flg is '南铝业务标志';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.ocup_pool_water_level_amt is '占用池水位金额';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.asset_pool_agt_sign_tm is '资产池协议签署时间';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.curr_brwer_flg is '当前借款人标志';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.aldy_sign_pool_fin_agt_flg is '已签订池融资协议标志';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.asset_pool_higt_lmt_guar_cont_id is '资产池最高额担保合同编号';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_addit_info_h.etl_timestamp is 'ETL处理时间戳';
