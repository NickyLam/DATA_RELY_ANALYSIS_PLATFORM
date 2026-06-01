/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dilg_quot_ctr_nt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dilg_quot_ctr_nt
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dilg_quot_ctr_nt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dilg_quot_ctr_nt(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,ctr_nt_tab_id varchar2(60) -- 成交单表编号
    ,batch_id varchar2(60) -- 批次编号
    ,ctr_nt_id varchar2(60) -- 成交单编号
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,bill_type_cd varchar2(10) -- 票据类型代码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,bag_way_cd varchar2(10) -- 成交方式代码
    ,tra_dt date -- 成交日期
    ,bag_tm varchar2(10) -- 成交时间
    ,bag_status_cd varchar2(10) -- 成交状态代码
    ,clear_status_cd varchar2(10) -- 清算状态代码
    ,quot_bill_id varchar2(60) -- 报价单编号
    ,mem_org_cd varchar2(10) -- 会员机构代码
    ,non_lp_prod_id varchar2(60) -- 非法人产品编号
    ,dealer_id varchar2(60) -- 交易员编号
    ,cap_acct varchar2(90) -- 资金账户
    ,cntpty_org_cd varchar2(10) -- 对手机构代码
    ,cntpty_dealer_id varchar2(60) -- 对手交易员编号
    ,cntpty_cap_acct varchar2(90) -- 对手资金账户
    ,quot_bill_status_cd varchar2(10) -- 报价单状态代码
    ,dcotin_rs_cd varchar2(10) -- 中止原因代码
    ,lock_flg varchar2(10) -- 锁定标志
    ,final_modif_tm timestamp -- 最后修改时间
    ,exp_clear_status_cd varchar2(10) -- 到期清算状态代码
    ,nest_lock_ind varchar2(10) -- 嵌套锁标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_dilg_quot_ctr_nt to ${icl_schema};
grant select on ${iml_schema}.agt_dilg_quot_ctr_nt to ${idl_schema};
grant select on ${iml_schema}.agt_dilg_quot_ctr_nt to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dilg_quot_ctr_nt is '对话报价成交单';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.ctr_nt_tab_id is '成交单表编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.batch_id is '批次编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bag_way_cd is '成交方式代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.tra_dt is '成交日期';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bag_tm is '成交时间';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.bag_status_cd is '成交状态代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.quot_bill_id is '报价单编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.mem_org_cd is '会员机构代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.non_lp_prod_id is '非法人产品编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.cap_acct is '资金账户';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.cntpty_org_cd is '对手机构代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.cntpty_dealer_id is '对手交易员编号';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.cntpty_cap_acct is '对手资金账户';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.quot_bill_status_cd is '报价单状态代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.dcotin_rs_cd is '中止原因代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.lock_flg is '锁定标志';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.exp_clear_status_cd is '到期清算状态代码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.nest_lock_ind is '嵌套锁标志';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.create_dt is '创建日期';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.update_dt is '更新日期';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dilg_quot_ctr_nt.etl_timestamp is 'ETL处理时间戳';
