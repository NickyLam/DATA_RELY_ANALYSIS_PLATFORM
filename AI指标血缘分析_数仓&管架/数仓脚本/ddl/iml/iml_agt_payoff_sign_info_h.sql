/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_payoff_sign_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_payoff_sign_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_payoff_sign_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payoff_sign_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_id varchar2(100) -- 签约编号
    ,sign_type_cd varchar2(30) -- 签约类型代码
    ,entr_acct_id varchar2(100) -- 委托账户编号
    ,entr_acct_name varchar2(750) -- 委托账户名称
    ,tel_num varchar2(60) -- 电话号码
    ,corp_addr varchar2(150) -- 公司地址
    ,intnal_acct_id varchar2(100) -- 内部账户编号
    ,intnal_acct_name varchar2(750) -- 内部账户名称
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,sign_dt date -- 签约日期
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,rels_dt date -- 解约日期
    ,rels_teller_id varchar2(100) -- 解约柜员编号
    ,agt_status_cd varchar2(30) -- 协议状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,obank_flg varchar2(10) -- 他行标志
    ,obank_acct_id varchar2(100) -- 他行账户编号
    ,obank_acct_name varchar2(750) -- 他行账户名称
    ,obank_bank_no varchar2(100) -- 他行行号
    ,obank_bank_name varchar2(375) -- 他行行名
    ,tran_inside_acct_id varchar2(100) -- 过渡内部户账户编号
    ,tran_inside_acct_name varchar2(750) -- 过渡内部户账户名称
    ,rfued_flg varchar2(10) -- 退款中标志
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
grant select on ${iml_schema}.agt_payoff_sign_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_payoff_sign_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_payoff_sign_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_payoff_sign_info_h is '代发代扣签约信息历史';
comment on column ${iml_schema}.agt_payoff_sign_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.sign_id is '签约编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.sign_type_cd is '签约类型代码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.entr_acct_id is '委托账户编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.entr_acct_name is '委托账户名称';
comment on column ${iml_schema}.agt_payoff_sign_info_h.tel_num is '电话号码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.corp_addr is '公司地址';
comment on column ${iml_schema}.agt_payoff_sign_info_h.intnal_acct_id is '内部账户编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.intnal_acct_name is '内部账户名称';
comment on column ${iml_schema}.agt_payoff_sign_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_payoff_sign_info_h.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_payoff_sign_info_h.rels_teller_id is '解约柜员编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.agt_status_cd is '协议状态代码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.obank_flg is '他行标志';
comment on column ${iml_schema}.agt_payoff_sign_info_h.obank_acct_id is '他行账户编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.obank_acct_name is '他行账户名称';
comment on column ${iml_schema}.agt_payoff_sign_info_h.obank_bank_no is '他行行号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.obank_bank_name is '他行行名';
comment on column ${iml_schema}.agt_payoff_sign_info_h.tran_inside_acct_id is '过渡内部户账户编号';
comment on column ${iml_schema}.agt_payoff_sign_info_h.tran_inside_acct_name is '过渡内部户账户名称';
comment on column ${iml_schema}.agt_payoff_sign_info_h.rfued_flg is '退款中标志';
comment on column ${iml_schema}.agt_payoff_sign_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_payoff_sign_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_payoff_sign_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_payoff_sign_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_payoff_sign_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_payoff_sign_info_h.etl_timestamp is 'ETL处理时间戳';
