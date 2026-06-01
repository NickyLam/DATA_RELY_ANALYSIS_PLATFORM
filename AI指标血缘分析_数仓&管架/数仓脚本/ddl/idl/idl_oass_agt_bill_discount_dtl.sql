/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_discount_dtl
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_discount_dtl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_discount_dtl(
etl_dt date --ETL处理日期
,discount_dtl_id varchar2(60) --转贴现明细编号
,cont_id varchar2(60) --合同编号
,bill_id varchar2(60) --票据编号
,bill_amt number(30,2) --贴现票据金额
,bill_exp_dt date --票据到期日期
,actl_exp_dt date --实际到期日期
,surp_tenor number(10,0) --剩余期限
,exp_surp_tenor number(10,0) --到期剩余期限
,int_paybl number(30,2) --应付利息
,exp_int_paybl number(30,2) --到期应付利息
,stl_amt number(30,2) --转贴现金额
,exp_stl_amt number(30,2) --到期结算金额
,lmt_ocup_status_cd varchar2(10) --额度占用状态代码
,proc_status_cd varchar2(10) --处理状态代码
,entry_status_cd varchar2(10) --记账状态代码
,valid_flg varchar2(10) --有效标志
,crdt_main_type_cd varchar2(30) --信用主体类型代码
,crdt_main_id varchar2(60) --信用主体编号
,bill_intrv_std_amt number(30,2) --票据区间标准金额
,bf_split_intrv_id varchar2(60) --拆前区间编号
,init_bill_amt number(30,2) --原始票据金额
,bill_num varchar2(60) --票据号码
,bill_sub_intrv_id varchar2(60) --票据子区间号
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,agt_id varchar2(60) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bill_discount_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_discount_dtl is '票据转贴现明细';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.discount_dtl_id is '转贴现明细编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.cont_id is '合同编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_id is '票据编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_amt is '贴现票据金额';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_exp_dt is '票据到期日期';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.actl_exp_dt is '实际到期日期';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.surp_tenor is '剩余期限';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.exp_surp_tenor is '到期剩余期限';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.int_paybl is '应付利息';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.exp_int_paybl is '到期应付利息';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.stl_amt is '转贴现金额';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.exp_stl_amt is '到期结算金额';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.lmt_ocup_status_cd is '额度占用状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.proc_status_cd is '处理状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.valid_flg is '有效标志';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.crdt_main_type_cd is '信用主体类型代码';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.crdt_main_id is '信用主体编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_intrv_std_amt is '票据区间标准金额';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bf_split_intrv_id is '拆前区间编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.init_bill_amt is '原始票据金额';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_num is '票据号码';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.bill_sub_intrv_id is '票据子区间号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bill_discount_dtl.lp_id is '法人编号';

