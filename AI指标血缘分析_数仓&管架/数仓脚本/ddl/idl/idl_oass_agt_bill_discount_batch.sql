/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_discount_batch
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_discount_batch purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_discount_batch(
etl_dt date --ETL处理日期
,hq_org_id varchar2(60) --总行机构编号
,cont_id varchar2(60) --合同编号
,appl_dt date --申请日期
,prod_id varchar2(60) --产品编号
,std_prod_id varchar2(60) --标准产品编号
,bus_dt date --转贴现日期
,quot_bill_id varchar2(60) --报价单编号
,bus_type_cd varchar2(10) --业务类型代码
,sys_in_flg varchar2(10) --系统外标志
,send_msg_flg varchar2(30) --发送报文标志
,ctr_nt_id varchar2(60) --成交单编号
,tran_dir_cd varchar2(10) --交易方向代码
,bus_org_id varchar2(60) --业务机构编号
,acct_instit_id varchar2(60) --账务机构编号
,tran_teller_id varchar2(60) --交易柜员编号
,cust_mgr_id varchar2(60) --客户经理编号
,dept_id varchar2(60) --部门编号
,cust_id varchar2(60) --客户编号
,cust_name varchar2(200) --客户名称
,cust_belong_bank_no varchar2(60) --客户所属行行号
,cust_belong_org_id varchar2(60) --客户所属机构编号
,bill_type_cd varchar2(10) --票据类型代码
,bill_med_cd varchar2(10) --票据介质代码
,bill_cnt number(10,0) --票据张数
,bill_tot number(30,2) --票据总额
,repo_amt number(30,2) --回购金额
,hold_tenor number(10,0) --持票期限
,part_bag_option_flg varchar2(10) --部分成交选项标志
,quot_valid_tm timestamp(6) --报价有效时间
,clear_speed_cd varchar2(10) --清算速度代码
,clear_type_cd varchar2(10) --清算类型代码
,latest_stl_tm timestamp(6) --最晚结算时间
,stl_way_cd varchar2(10) --结算方式代码
,stl_amt number(30,2) --转贴现金额
,exp_stl_amt number(30,2) --到期结算金额
,stl_dt date --结算日期
,exp_stl_dt date --到期结算日期
,int_rat number(18,8) --利率
,exp_int_rat number(18,8) --到期利率
,int_paybl number(30,2) --应付利息
,exp_int_paybl number(30,2) --到期应付利息
,yld_rat number(18,6) --收益率
,select_type_cd varchar2(10) --挑票类型代码
,bill_pkg_id varchar2(60) --票据包编号
,crdt_check_status_cd varchar2(10) --授信检查状态代码
,entry_status_cd varchar2(10) --记账状态代码
,msg_status_cd varchar2(10) --报文状态代码
,clear_status_cd varchar2(10) --清算状态代码
,final_modif_tm timestamp(6) --最后修改时间
,apv_status_cd varchar2(10) --审批状态代码
,modif_flg varchar2(10) --修改标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,asset_thd_cls_cd varchar2(30) --资产三分类代码
,remark_1 varchar2(500) --
,batch_id varchar2(60) --批次编号
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
grant select on ${idl_schema}.oass_agt_bill_discount_batch to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_discount_batch is '票据转贴现批次';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.hq_org_id is '总行机构编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cont_id is '合同编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.appl_dt is '申请日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bus_dt is '转贴现日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.quot_bill_id is '报价单编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bus_type_cd is '业务类型代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.sys_in_flg is '系统外标志';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.send_msg_flg is '发送报文标志';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.ctr_nt_id is '成交单编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.tran_dir_cd is '交易方向代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bus_org_id is '业务机构编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.tran_teller_id is '交易柜员编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.dept_id is '部门编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cust_belong_bank_no is '客户所属行行号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.cust_belong_org_id is '客户所属机构编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bill_cnt is '票据张数';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bill_tot is '票据总额';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.repo_amt is '回购金额';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.hold_tenor is '持票期限';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.part_bag_option_flg is '部分成交选项标志';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.quot_valid_tm is '报价有效时间';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.clear_speed_cd is '清算速度代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.clear_type_cd is '清算类型代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.latest_stl_tm is '最晚结算时间';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.stl_way_cd is '结算方式代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.stl_amt is '转贴现金额';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.exp_stl_amt is '到期结算金额';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.stl_dt is '结算日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.exp_stl_dt is '到期结算日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.int_rat is '利率';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.exp_int_rat is '到期利率';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.int_paybl is '应付利息';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.exp_int_paybl is '到期应付利息';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.yld_rat is '收益率';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.select_type_cd is '挑票类型代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.bill_pkg_id is '票据包编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.crdt_check_status_cd is '授信检查状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.msg_status_cd is '报文状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.clear_status_cd is '清算状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.apv_status_cd is '审批状态代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.modif_flg is '修改标志';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.remark_1 is '';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.batch_id is '批次编号';
comment on column ${idl_schema}.oass_agt_bill_discount_batch.lp_id is '法人编号';

