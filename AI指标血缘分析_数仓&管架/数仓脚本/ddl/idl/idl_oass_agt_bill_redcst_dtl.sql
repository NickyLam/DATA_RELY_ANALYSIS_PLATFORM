/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_redcst_dtl
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_redcst_dtl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_redcst_dtl(
etl_dt date --ETL处理日期
,redcst_dtl_id varchar2(60) --再贴现明细编号
,batch_id varchar2(60) --批次编号
,bill_id varchar2(60) --票据编号
,fac_val_amt number(30,2) --票面金额
,bill_exp_dt date --票据到期日期
,actl_exp_dt date --实际到期日期
,surp_tenor number(10,0) --剩余期限
,int_paybl number(30,2) --应付利息
,stl_amt number(30,2) --转贴现金额
,exp_stl_amt number(30,2) --到期结算金额
,lmt_ocup_status_cd varchar2(10) --额度占用状态代码
,proc_status_cd varchar2(10) --处理状态代码
,entry_status_cd varchar2(10) --记账状态代码
,valid_flg varchar2(10) --有效标志
,discount_bill_flg varchar2(10) --转贴现票据标志
,remote_bill_flg varchar2(10) --异地票据标志
,policy_std_flg varchar2(10) --政策标准标志
,refuse_flg varchar2(10) --拒绝标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,init_bill_amt number(30,2) --
,bill_num varchar2(60) --
,bf_split_intrv_id varchar2(60) --
,bill_intrv_std_amt number(30,2) --
,bill_sub_intrv_id varchar2(60) --
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
grant select on ${idl_schema}.oass_agt_bill_redcst_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_redcst_dtl is '票据再贴现明细';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.redcst_dtl_id is '再贴现明细编号';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.batch_id is '批次编号';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bill_id is '票据编号';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.fac_val_amt is '票面金额';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bill_exp_dt is '票据到期日期';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.actl_exp_dt is '实际到期日期';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.surp_tenor is '剩余期限';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.int_paybl is '应付利息';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.stl_amt is '转贴现金额';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.exp_stl_amt is '到期结算金额';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.lmt_ocup_status_cd is '额度占用状态代码';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.proc_status_cd is '处理状态代码';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.valid_flg is '有效标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.discount_bill_flg is '转贴现票据标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.remote_bill_flg is '异地票据标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.policy_std_flg is '政策标准标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.refuse_flg is '拒绝标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.init_bill_amt is '';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bill_num is '';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bf_split_intrv_id is '';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bill_intrv_std_amt is '';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.bill_sub_intrv_id is '';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bill_redcst_dtl.lp_id is '法人编号';

