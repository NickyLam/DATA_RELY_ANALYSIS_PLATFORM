/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_invest_cust_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_invest_cust_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_invest_cust_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_invest_cust_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,fin_dt date -- 财务日期
    ,invest_cust_flg varchar2(10) -- 投资级客户标志
    ,apv_status_cd varchar2(100) -- 审批状态代码
    ,estate_corp_flg varchar2(10) -- 房地产企业标志
    ,gover_fin_plat_cred_rht_flg varchar2(10) -- 政府融资平台债权标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,up_date date -- 更新日期
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
grant select on ${iml_schema}.agt_invest_cust_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_invest_cust_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_invest_cust_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_invest_cust_info_h is '投资级客户信息历史';
comment on column ${iml_schema}.agt_invest_cust_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.flow_num is '流水号';
comment on column ${iml_schema}.agt_invest_cust_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_invest_cust_info_h.fin_dt is '财务日期';
comment on column ${iml_schema}.agt_invest_cust_info_h.invest_cust_flg is '投资级客户标志';
comment on column ${iml_schema}.agt_invest_cust_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_invest_cust_info_h.estate_corp_flg is '房地产企业标志';
comment on column ${iml_schema}.agt_invest_cust_info_h.gover_fin_plat_cred_rht_flg is '政府融资平台债权标志';
comment on column ${iml_schema}.agt_invest_cust_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_invest_cust_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_invest_cust_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_invest_cust_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_invest_cust_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_invest_cust_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_invest_cust_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_invest_cust_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_invest_cust_info_h.etl_timestamp is 'ETL处理时间戳';
