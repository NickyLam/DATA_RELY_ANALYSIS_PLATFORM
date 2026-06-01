/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_elec_bill_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_elec_bill_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_elec_bill_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_elec_bill_info_h(
    bill_id varchar2(100) -- 票据编号
    ,lp_id varchar2(60) -- 法人编号
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_num varchar2(100) -- 票据号码
    ,bill_amt number(30,2) -- 贴现票据金额
    ,tran_flow_num varchar2(100) -- 交易编号
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,tran_cd varchar2(30) -- 转让代码
    ,drawer_cate_cd varchar2(30) -- 出票人类别代码
    ,drawer_orgnz_cd varchar2(30) -- 出票人组织机构代码
    ,drawer_name varchar2(750) -- 出票人名称
    ,drawer_acct_id varchar2(100) -- 出票人账户编号
    ,drawer_open_bank_no varchar2(100) -- 出票人开户行行号
    ,recver_name varchar2(750) -- 收款人名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,recver_open_bank_no varchar2(100) -- 收款人开户行行号
    ,accptor_cate_cd varchar2(30) -- 承兑人类别代码
    ,accptor_orgnz_cd varchar2(30) -- 承兑人组织机构代码
    ,accptor_name varchar2(1000) -- 承兑人名称
    ,accptor_acct_id varchar2(100) -- 承兑人账户编号
    ,accptor_open_bank_no varchar2(100) -- 承兑人开户行行号
    ,bill_obg_cate_cd varchar2(30) -- 票据权利人类别代码
    ,bill_obg_orgnz_cd varchar2(30) -- 票据权利人组织机构代码
    ,bill_obg_name varchar2(750) -- 票据权利人名称
    ,bill_obg_acct_id varchar2(100) -- 票据权利人账户编号
    ,bill_obg_open_bank_no varchar2(100) -- 票据权利人开户行行号
    ,bill_last_status_cd varchar2(30) -- 票据上一状态代码
    ,bill_send_ps_status_cd varchar2(30) -- 票据发送人状态代码
    ,bill_recv_ps_status_cd varchar2(30) -- 票据接收人状态代码
    ,create_tm timestamp -- 创建时间
    ,lock_flg varchar2(30) -- 锁定标志
    ,curr_status_cd varchar2(30) -- 当前状态代码
    ,recs_type_cd varchar2(30) -- 追索类型代码
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
grant select on ${iml_schema}.agt_elec_bill_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_elec_bill_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_elec_bill_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_elec_bill_info_h is '电子票据信息历史';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_num is '票据号码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_amt is '贴现票据金额';
comment on column ${iml_schema}.agt_elec_bill_info_h.tran_flow_num is '交易编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.draw_dt is '出票日期';
comment on column ${iml_schema}.agt_elec_bill_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_elec_bill_info_h.tran_cd is '转让代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.drawer_cate_cd is '出票人类别代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.drawer_orgnz_cd is '出票人组织机构代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.drawer_name is '出票人名称';
comment on column ${iml_schema}.agt_elec_bill_info_h.drawer_acct_id is '出票人账户编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.drawer_open_bank_no is '出票人开户行行号';
comment on column ${iml_schema}.agt_elec_bill_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_elec_bill_info_h.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.agt_elec_bill_info_h.accptor_cate_cd is '承兑人类别代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.accptor_orgnz_cd is '承兑人组织机构代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.accptor_name is '承兑人名称';
comment on column ${iml_schema}.agt_elec_bill_info_h.accptor_acct_id is '承兑人账户编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.accptor_open_bank_no is '承兑人开户行行号';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_obg_cate_cd is '票据权利人类别代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_obg_orgnz_cd is '票据权利人组织机构代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_obg_name is '票据权利人名称';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_obg_acct_id is '票据权利人账户编号';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_obg_open_bank_no is '票据权利人开户行行号';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_last_status_cd is '票据上一状态代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_send_ps_status_cd is '票据发送人状态代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.bill_recv_ps_status_cd is '票据接收人状态代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.agt_elec_bill_info_h.lock_flg is '锁定标志';
comment on column ${iml_schema}.agt_elec_bill_info_h.curr_status_cd is '当前状态代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.recs_type_cd is '追索类型代码';
comment on column ${iml_schema}.agt_elec_bill_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_elec_bill_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_elec_bill_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_elec_bill_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_elec_bill_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_elec_bill_info_h.etl_timestamp is 'ETL处理时间戳';
