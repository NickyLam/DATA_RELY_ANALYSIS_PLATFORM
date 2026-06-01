/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_discnt_dtl
CreateDate: 20221108
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_discnt_dtl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_discnt_dtl(
etl_dt date --ETL处理日期
,agt_id varchar2(60) --协议编号
,lp_id varchar2(60) --法人编号
,buy_dtl_id varchar2(60) --买入明细编号
,buy_way_cd varchar2(10) --买入方式代码
,batch_id varchar2(60) --批次编号
,discnt_type_cd varchar2(60) --贴现类型代码
,bill_id varchar2(60) --票据编号
,city_wide_flg varchar2(10) --同城标志
,rher_name varchar2(250) --前手名称
,int_accr_exp_dt date --计息到期日期
,defer_days number(10) --顺延天数
,int_accr_days number(10) --计息天数
,not_ngbl_flg varchar2(10) --不得转让标志
,int_amt number(30,2) --利息金额
,onl_clear_flg varchar2(10) --线上清算标志
,buyer_pay_int number(30,2) --买方付息利息
,actl_amt number(30,2) --贴现金额
,discnt_appl_enter_acct_num varchar2(60) --贴现申请入账账号
,discnt_appl_enter_acct_bk_no varchar2(60) --贴现申请入账行行号
,dscnt_props_cate_cd varchar2(10) --贴出人类别代码
,dscnt_props_name varchar2(250) --贴出人名称
,dscnt_props_orgnz_cd varchar2(30) --贴出人组织机构代码
,dscnt_props_acct_num varchar2(60) --贴出人账号
,dscnt_props_udtake_bk_no varchar2(60) --贴出人承接行行号
,tran_cont_id varchar2(100) --交易合同编号
,entry_dt date --记账日期
,entry_status_cd varchar2(10) --记账状态代码
,recv_dt date --签收日期
,buy_dtl_status_cd varchar2(10) --买入明细状态代码
,final_modif_tm timestamp(6) --最后修改时间
,modif_teller_id varchar2(100) --修改柜员编号
,bill_sub_intrv_id varchar2(60) --票据子区间编号
,quick_discnt_status_cd varchar2(30) --秒贴状态代码
,quick_discnt_flg varchar2(10) --秒贴标志
,bill_src_cd varchar2(30) --票据来源代码
,crdt_out_acct_flow_num varchar2(60) --信贷出账流水号
,h_data_flg varchar2(100) --历史数据标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bill_discnt_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_discnt_dtl is '票据贴现明细';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.buy_dtl_id is '买入明细编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.buy_way_cd is '买入方式代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.batch_id is '批次编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.discnt_type_cd is '贴现类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.bill_id is '票据编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.city_wide_flg is '同城标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.rher_name is '前手名称';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.int_accr_exp_dt is '计息到期日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.defer_days is '顺延天数';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.int_accr_days is '计息天数';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.not_ngbl_flg is '不得转让标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.int_amt is '利息金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.onl_clear_flg is '线上清算标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.buyer_pay_int is '买方付息利息';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.actl_amt is '贴现金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.discnt_appl_enter_acct_num is '贴现申请入账账号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.discnt_appl_enter_acct_bk_no is '贴现申请入账行行号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.dscnt_props_cate_cd is '贴出人类别代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.dscnt_props_name is '贴出人名称';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.dscnt_props_orgnz_cd is '贴出人组织机构代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.dscnt_props_acct_num is '贴出人账号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.dscnt_props_udtake_bk_no is '贴出人承接行行号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.tran_cont_id is '交易合同编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.entry_dt is '记账日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.recv_dt is '签收日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.buy_dtl_status_cd is '买入明细状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.modif_teller_id is '修改柜员编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.bill_sub_intrv_id is '票据子区间编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.quick_discnt_status_cd is '秒贴状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.quick_discnt_flg is '秒贴标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.bill_src_cd is '票据来源代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.h_data_flg is '历史数据标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_dtl.id_mark is '增删标志';

