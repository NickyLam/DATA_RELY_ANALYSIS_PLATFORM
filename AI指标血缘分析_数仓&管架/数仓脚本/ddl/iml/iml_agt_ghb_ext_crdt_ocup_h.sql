/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ghb_ext_crdt_ocup_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ghb_ext_crdt_ocup_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ghb_ext_crdt_ocup_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,apv_form_num varchar2(100) -- 审批单号
    ,tran_odd_no varchar2(100) -- 交易单号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,intnal_vch_acct_id varchar2(100) -- 内部券账户编号
    ,acct_acctnt_cls_cd varchar2(30) -- 账户会计分类代码
    ,acct_b_cate_cd varchar2(30) -- 账簿类别代码
    ,crdt_side_cust_id varchar2(100) -- 授信方客户编号
    ,crdt_side_name varchar2(375) -- 授信方名称
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,occu_lmt number(30,8) -- 已占用额度
    ,ocup_surp_lmt number(30,8) -- 占用剩余额度
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
grant select on ${iml_schema}.agt_ghb_ext_crdt_ocup_h to ${icl_schema};
grant select on ${iml_schema}.agt_ghb_ext_crdt_ocup_h to ${idl_schema};
grant select on ${iml_schema}.agt_ghb_ext_crdt_ocup_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ghb_ext_crdt_ocup_h is '华兴外部授信占用历史';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.ser_num is '序列号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.apv_form_num is '审批单号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.tran_odd_no is '交易单号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.intnal_vch_acct_id is '内部券账户编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.acct_acctnt_cls_cd is '账户会计分类代码';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.acct_b_cate_cd is '账簿类别代码';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.crdt_side_cust_id is '授信方客户编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.crdt_side_name is '授信方名称';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.occu_lmt is '已占用额度';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.ocup_surp_lmt is '占用剩余额度';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ghb_ext_crdt_ocup_h.etl_timestamp is 'ETL处理时间戳';
