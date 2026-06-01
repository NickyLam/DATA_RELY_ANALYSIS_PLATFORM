/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_info(
etl_dt date --ETL处理日期
,lp_id varchar2(60) --法人编号
,bill_num varchar2(60) --票据号码
,role_src_cd varchar2(10) --角色来源代码
,discnt_batch_id varchar2(60) --贴现批次编号
,pbc_tranbl_flg varchar2(10) --人行可转让标志
,hxb_acpt_flg varchar2(10) --我行承兑标志
,bill_med_cd varchar2(10) --票据介质代码
,bill_type_cd varchar2(10) --票据类型代码
,draw_dt date --出票日期
,fac_val_exp_dt date --票面到期日期
,drawer_cate_cd varchar2(10) --出票人类别代码
,drawer_orgnz_cd varchar2(30) --出票人组织机构代码
,drawer_name varchar2(100) --出票人名称
,drawer_acct_num varchar2(60) --出票人账号
,drawer_open_bank_num varchar2(60) --出票人开户行号
,accptor_open_bank_name varchar2(250) --承兑人开户行名称
,drawer_open_bank_name varchar2(250) --出票人开户行名称
,accptor_cate_cd varchar2(30) --承兑人类别代码
,accptor_name varchar2(250) --承兑人名称
,accptor_open_bank_num varchar2(60) --承兑人开户行号
,accptor_acct_num varchar2(100) --承兑人账号
,recver_name varchar2(250) --收款人名称
,recver_acct_num varchar2(60) --收款人账号
,recver_open_bank_num varchar2(60) --收款人开户行号
,recver_open_bank_name varchar2(250) --收款人开户行名称
,bill_amt number(30,2) --贴现票据金额
,bill_belong_org_id varchar2(60) --票据所属机构编号
,bill_status_cd varchar2(30) --票据状态代码
,loss_flg varchar2(10) --挂失标志
,final_modif_operr_id varchar2(60) --最后修改操作员编号
,final_modif_tm timestamp(6) --最后修改时间
,receipt_flg varchar2(10) --小票标志
,redcst_flg varchar2(30) --再贴现标志
,h_data_flg varchar2(100) --历史数据标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,vouch_id varchar2(100) --凭证编号
,bill_id varchar2(60) --票据编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bill_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_info is '票据信息';
comment on column ${idl_schema}.oass_agt_bill_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_info.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_bill_info.bill_num is '票据号码';
comment on column ${idl_schema}.oass_agt_bill_info.role_src_cd is '角色来源代码';
comment on column ${idl_schema}.oass_agt_bill_info.discnt_batch_id is '贴现批次编号';
comment on column ${idl_schema}.oass_agt_bill_info.pbc_tranbl_flg is '人行可转让标志';
comment on column ${idl_schema}.oass_agt_bill_info.hxb_acpt_flg is '我行承兑标志';
comment on column ${idl_schema}.oass_agt_bill_info.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.oass_agt_bill_info.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.oass_agt_bill_info.draw_dt is '出票日期';
comment on column ${idl_schema}.oass_agt_bill_info.fac_val_exp_dt is '票面到期日期';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_cate_cd is '出票人类别代码';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_orgnz_cd is '出票人组织机构代码';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_name is '出票人名称';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_acct_num is '出票人账号';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_open_bank_num is '出票人开户行号';
comment on column ${idl_schema}.oass_agt_bill_info.accptor_open_bank_name is '承兑人开户行名称';
comment on column ${idl_schema}.oass_agt_bill_info.drawer_open_bank_name is '出票人开户行名称';
comment on column ${idl_schema}.oass_agt_bill_info.accptor_cate_cd is '承兑人类别代码';
comment on column ${idl_schema}.oass_agt_bill_info.accptor_name is '承兑人名称';
comment on column ${idl_schema}.oass_agt_bill_info.accptor_open_bank_num is '承兑人开户行号';
comment on column ${idl_schema}.oass_agt_bill_info.accptor_acct_num is '承兑人账号';
comment on column ${idl_schema}.oass_agt_bill_info.recver_name is '收款人名称';
comment on column ${idl_schema}.oass_agt_bill_info.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.oass_agt_bill_info.recver_open_bank_num is '收款人开户行号';
comment on column ${idl_schema}.oass_agt_bill_info.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.oass_agt_bill_info.bill_amt is '贴现票据金额';
comment on column ${idl_schema}.oass_agt_bill_info.bill_belong_org_id is '票据所属机构编号';
comment on column ${idl_schema}.oass_agt_bill_info.bill_status_cd is '票据状态代码';
comment on column ${idl_schema}.oass_agt_bill_info.loss_flg is '挂失标志';
comment on column ${idl_schema}.oass_agt_bill_info.final_modif_operr_id is '最后修改操作员编号';
comment on column ${idl_schema}.oass_agt_bill_info.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.oass_agt_bill_info.receipt_flg is '小票标志';
comment on column ${idl_schema}.oass_agt_bill_info.redcst_flg is '再贴现标志';
comment on column ${idl_schema}.oass_agt_bill_info.h_data_flg is '历史数据标志';
comment on column ${idl_schema}.oass_agt_bill_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bill_info.vouch_id is '凭证编号';
comment on column ${idl_schema}.oass_agt_bill_info.bill_id is '票据编号';

