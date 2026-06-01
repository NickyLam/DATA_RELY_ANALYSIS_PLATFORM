/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_direct_mchnt_inf_tmp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp(
    mchtserial varchar2(4) -- 
    ,mcht_no varchar2(15) -- 
    ,mcht_nm varchar2(60) -- 
    ,mcht_official_nm varchar2(60) -- 
    ,mcht_addr varchar2(250) -- 
    ,acq_bank varchar2(14) -- 
    ,open_stlno varchar2(160) -- 
    ,settle_bank_no varchar2(40) -- 
    ,contact varchar2(30) -- 
    ,contact_nick varchar2(30) -- 
    ,contact_job varchar2(50) -- 
    ,contact_tel varchar2(20) -- 
    ,contact_fix varchar2(20) -- 
    ,electrofax varchar2(15) -- 
    ,install_contact varchar2(30) -- 
    ,install_tel varchar2(20) -- 
    ,install_fix varchar2(20) -- 
    ,busi_type_id varchar2(6) -- 
    ,fee_type varchar2(1) -- 
    ,back_rate number(15,2) -- 
    ,fee_mng number(15,2) -- 
    ,enable_dt varchar2(8) -- 
    ,enable_lmt_dt varchar2(8) -- 
    ,expired_date varchar2(8) -- 
    ,reg_dt varchar2(8) -- 
    ,opr_unit varchar2(20) -- 
    ,sign_man varchar2(16) -- 
    ,status varchar2(1) -- 
    ,is_costfee varchar2(1) -- 
    ,contract_cd varchar2(20) -- 
    ,press_card varchar2(1) -- 
    ,press_card_dt varchar2(8) -- 
    ,addition_cd varchar2(60) -- 
    ,freeze varchar2(1) -- 
    ,postcode varchar2(6) -- 
    ,area_cd varchar2(6) -- 
    ,isrisk varchar2(1) -- 
    ,apply_term number(22) -- 
    ,apply_cd varchar2(4) -- 
    ,dealwith varchar2(1) -- 
    ,dealwith_cd varchar2(2) -- 
    ,dealwith_dsp varchar2(255) -- 
    ,finish varchar2(1) -- 
    ,under_platform varchar2(8) -- 
    ,fee_rate2 number(15,2) -- 
    ,fee_rate_in varchar2(6) -- 
    ,fee_rate_out varchar2(6) -- 
    ,acct_nm varchar2(60) -- 
    ,origi_mcht_cd varchar2(15) -- 
    ,buss_type varchar2(1) -- 
    ,buss_cd varchar2(15) -- 
    ,licence_no varchar2(70) -- 
    ,spe_settle_tp varchar2(3) -- 
    ,allot_algo varchar2(5) -- 
    ,allot_index varchar2(5) -- 
    ,allot_ins varchar2(8) -- 
    ,open_bank_no varchar2(20) -- 
    ,exp_type varchar2(1) -- 
    ,bus_lic_tp varchar2(20) -- 
    ,invo_open_bank varchar2(100) -- 
    ,invo_acct varchar2(40) -- 
    ,invo_acct_nm varchar2(100) -- 
    ,apply_prefer varchar2(1) -- 
    ,brand varchar2(32) -- 
    ,reg_addr varchar2(90) -- 
    ,fee_crd varchar2(6) -- 
    ,fee_dbt varchar2(6) -- 
    ,fee_bdb varchar2(6) -- 
    ,trans_ctrl varchar2(2) -- 
    ,apply_sta varchar2(1) -- 
    ,deal_sta varchar2(1) -- 
    ,filename varchar2(80) -- 
    ,reserve1 varchar2(20) -- 
    ,reserve2 varchar2(40) -- 
    ,reserve3 varchar2(60) -- 
    ,mcht_type varchar2(2) -- 
    ,conn_type varchar2(1) -- 
    ,acq_inst_id varchar2(13) -- 
    ,mcc varchar2(4) -- 
    ,licence_nm varchar2(100) -- 
    ,tax_no varchar2(30) -- 
    ,bank_licence_no varchar2(20) -- 
    ,director_nm varchar2(100) -- 
    ,director_no varchar2(70) -- 
    ,scale varchar2(20) -- 
    ,clear_type varchar2(2) -- 
    ,settle_type varchar2(1) -- 
    ,oper_id varchar2(12) -- 
    ,create_date varchar2(14) -- 
    ,id varchar2(14) -- 
    ,rec_upd_ts varchar2(14) -- 
    ,upd_oper varchar2(12) -- 
    ,inspact_date varchar2(14) -- 
    ,inspact_cycle varchar2(4) -- 
    ,return_sta varchar2(1) -- 
    ,train_date varchar2(14) -- 
    ,train_cycle varchar2(4) -- 
    ,exp_bank varchar2(100) -- //用于拓展行
    ,out_mcht_no varchar2(15) -- 
    ,comm_email varchar2(40) -- 
    ,comm_mobil varchar2(30) -- 
    ,artif_certif_tp varchar2(20) -- 
    ,manager_tel varchar2(30) -- 
    ,agr_br varchar2(6) -- 
    ,net_tel varchar2(30) -- 
    ,ztflag varchar2(1) -- 
    ,acct_chnl varchar2(1) -- 
    ,prof_type varchar2(2) -- 业务种类
    ,license_deadline varchar2(8) -- 法定代表人或负责人证件有效期截止日
    ,acc_add varchar2(100) -- 网络商户登记网址
    ,acc_ip varchar2(50) -- 网络商户登记ip
    ,acc_icp_no varchar2(20) -- 网络商户icp备案/许可证号
    ,reg_amt varchar2(18) -- 注册资本金
    ,coo_state varchar2(2) -- 合作状态
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp is '直联商户信息临时表';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mchtserial is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcht_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcht_official_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcht_addr is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acq_bank is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.open_stlno is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.settle_bank_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contact is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contact_nick is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contact_job is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contact_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contact_fix is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.electrofax is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.install_contact is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.install_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.install_fix is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.busi_type_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.back_rate is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_mng is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.enable_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.enable_lmt_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.expired_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reg_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.opr_unit is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.sign_man is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.status is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.is_costfee is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.contract_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.press_card is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.press_card_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.addition_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.freeze is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.postcode is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.area_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.isrisk is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.apply_term is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.apply_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.dealwith is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.dealwith_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.dealwith_dsp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.finish is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.under_platform is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_rate2 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_rate_in is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_rate_out is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acct_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.origi_mcht_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.buss_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.buss_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.licence_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.spe_settle_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.allot_algo is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.allot_index is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.allot_ins is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.open_bank_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.exp_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.bus_lic_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.invo_open_bank is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.invo_acct is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.invo_acct_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.apply_prefer is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.brand is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reg_addr is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_crd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_dbt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.fee_bdb is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.trans_ctrl is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.apply_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.deal_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.filename is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reserve1 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reserve2 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reserve3 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcht_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.conn_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acq_inst_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.mcc is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.licence_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.tax_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.bank_licence_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.director_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.director_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.scale is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.clear_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.settle_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.oper_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.create_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.upd_oper is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.inspact_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.inspact_cycle is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.return_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.train_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.train_cycle is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.exp_bank is '//用于拓展行';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.comm_email is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.comm_mobil is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.artif_certif_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.manager_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.agr_br is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.net_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.ztflag is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acct_chnl is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.prof_type is '业务种类';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.license_deadline is '法定代表人或负责人证件有效期截止日';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acc_add is '网络商户登记网址';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acc_ip is '网络商户登记ip';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.acc_icp_no is '网络商户icp备案/许可证号';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.reg_amt is '注册资本金';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.coo_state is '合作状态';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf_tmp.etl_timestamp is 'ETL处理时间戳';
