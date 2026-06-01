/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_log_next_claim_bus_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_log_next_claim_bus_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_log_next_claim_bus_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_next_claim_bus_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,intnal_id varchar2(100) -- 内部编号
    ,log_claim_id varchar2(100) -- 保函索赔编号
    ,log_agt_id varchar2(100) -- 保函协议编号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_name varchar2(750) -- 交易名称
    ,appl_dt date -- 申请日期
    ,create_date date -- 创建日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,claim_kind_cd varchar2(30) -- 索赔种类代码
    ,claim_type_cd varchar2(30) -- 索赔类型代码
    ,claim_dt date -- 索赔日期
    ,cancel_log_next_pay_flg varchar2(10) -- 取消保函下付款标志
    ,refuse_revid_msg_dt date -- 拒接报文日期
    ,payer_type_id varchar2(100) -- 付款人类型编号
    ,accptor_type_id varchar2(100) -- 承兑人类型编号
    ,free_pay_flg varchar2(10) -- 自由付款标志
    ,bus_oper_org_id varchar2(100) -- 业务经办机构编号
    ,bus_belong_org_id varchar2(100) -- 业务所属机构编号
    ,nra_pay_flg varchar2(10) -- NRA付款标志
    ,clear_chn_cd varchar2(30) -- 清算渠道代码
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
grant select on ${iml_schema}.agt_log_next_claim_bus_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_log_next_claim_bus_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_log_next_claim_bus_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_log_next_claim_bus_info_h is '保函下索赔业务信息历史';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.intnal_id is '内部编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.log_claim_id is '保函索赔编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.log_agt_id is '保函协议编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.tran_name is '交易名称';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.create_date is '创建日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.claim_kind_cd is '索赔种类代码';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.claim_type_cd is '索赔类型代码';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.claim_dt is '索赔日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.cancel_log_next_pay_flg is '取消保函下付款标志';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.refuse_revid_msg_dt is '拒接报文日期';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.payer_type_id is '付款人类型编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.accptor_type_id is '承兑人类型编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.free_pay_flg is '自由付款标志';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.bus_oper_org_id is '业务经办机构编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.bus_belong_org_id is '业务所属机构编号';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.nra_pay_flg is 'NRA付款标志';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.clear_chn_cd is '清算渠道代码';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_log_next_claim_bus_info_h.etl_timestamp is 'ETL处理时间戳';
