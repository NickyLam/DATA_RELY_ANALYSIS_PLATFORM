/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_direct_mchnt_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_direct_mchnt_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_direct_mchnt_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_direct_mchnt_inf(
    mchtserial varchar2(6) -- 
    ,mcht_no varchar2(23) -- 
    ,mcht_nm varchar2(90) -- 
    ,mcht_official_nm varchar2(90) -- 
    ,mcht_addr varchar2(375) -- 
    ,acq_bank varchar2(21) -- 
    ,open_stlno varchar2(240) -- 
    ,settle_bank_no varchar2(60) -- 
    ,contact varchar2(45) -- 
    ,contact_nick varchar2(45) -- 
    ,contact_job varchar2(75) -- 
    ,contact_tel varchar2(30) -- 
    ,contact_fix varchar2(30) -- 
    ,electrofax varchar2(23) -- 
    ,install_contact varchar2(45) -- 
    ,install_tel varchar2(30) -- 
    ,install_fix varchar2(30) -- 
    ,busi_type_id varchar2(9) -- 
    ,fee_type varchar2(2) -- 
    ,back_rate number(15,2) -- 
    ,fee_mng number(15,2) -- 
    ,enable_dt varchar2(12) -- 
    ,enable_lmt_dt varchar2(12) -- 
    ,expired_date varchar2(12) -- 
    ,reg_dt varchar2(12) -- 
    ,opr_unit varchar2(30) -- 
    ,sign_man varchar2(24) -- 
    ,status varchar2(2) -- 
    ,is_costfee varchar2(2) -- 
    ,contract_cd varchar2(30) -- 
    ,press_card varchar2(2) -- 
    ,press_card_dt varchar2(12) -- 
    ,addition_cd varchar2(90) -- 
    ,freeze varchar2(2) -- 
    ,postcode varchar2(9) -- 
    ,area_cd varchar2(9) -- 
    ,isrisk varchar2(2) -- 
    ,apply_term number(22,0) -- 
    ,apply_cd varchar2(6) -- 
    ,dealwith varchar2(2) -- 
    ,dealwith_cd varchar2(3) -- 
    ,dealwith_dsp varchar2(383) -- 
    ,finish varchar2(2) -- 
    ,under_platform varchar2(12) -- 
    ,fee_rate2 number(15,2) -- 
    ,fee_rate_in varchar2(9) -- 
    ,fee_rate_out varchar2(9) -- 
    ,acct_nm varchar2(90) -- 
    ,origi_mcht_cd varchar2(23) -- 
    ,buss_type varchar2(2) -- 
    ,buss_cd varchar2(23) -- 
    ,licence_no varchar2(105) -- 
    ,spe_settle_tp varchar2(5) -- 
    ,allot_algo varchar2(8) -- 
    ,allot_index varchar2(8) -- 
    ,allot_ins varchar2(12) -- 
    ,open_bank_no varchar2(30) -- 
    ,exp_type varchar2(2) -- 
    ,bus_lic_tp varchar2(30) -- 
    ,invo_open_bank varchar2(150) -- 
    ,invo_acct varchar2(60) -- 
    ,invo_acct_nm varchar2(150) -- 
    ,apply_prefer varchar2(2) -- 
    ,brand varchar2(48) -- 
    ,reg_addr varchar2(135) -- 
    ,fee_crd varchar2(9) -- 
    ,fee_dbt varchar2(9) -- 
    ,fee_bdb varchar2(9) -- 
    ,trans_ctrl varchar2(3) -- 
    ,apply_sta varchar2(2) -- 
    ,deal_sta varchar2(2) -- 
    ,filename varchar2(120) -- 
    ,reserve1 varchar2(30) -- 
    ,reserve2 varchar2(60) -- 
    ,reserve3 varchar2(90) -- 
    ,mcht_type varchar2(3) -- 
    ,conn_type varchar2(2) -- 
    ,acq_inst_id varchar2(20) -- 
    ,mcc varchar2(6) -- 
    ,licence_nm varchar2(150) -- 
    ,tax_no varchar2(45) -- 
    ,bank_licence_no varchar2(30) -- 
    ,director_nm varchar2(150) -- 
    ,director_no varchar2(105) -- 
    ,scale varchar2(30) -- 
    ,clear_type varchar2(3) -- 
    ,settle_type varchar2(2) -- 
    ,oper_id varchar2(18) -- 
    ,create_date varchar2(21) -- 
    ,id varchar2(21) -- 
    ,rec_upd_ts varchar2(21) -- 
    ,upd_oper varchar2(18) -- 
    ,inspact_date varchar2(21) -- 
    ,inspact_cycle varchar2(6) -- 
    ,return_sta varchar2(2) -- 
    ,train_date varchar2(21) -- 
    ,train_cycle varchar2(6) -- 
    ,exp_bank varchar2(150) -- //用于拓展行
    ,out_mcht_no varchar2(23) -- 
    ,comm_email varchar2(60) -- 
    ,comm_mobil varchar2(45) -- 
    ,artif_certif_tp varchar2(30) -- 
    ,manager_tel varchar2(45) -- 
    ,agr_br varchar2(9) -- 
    ,net_tel varchar2(45) -- 
    ,ztflag varchar2(2) -- 
    ,acct_chnl varchar2(2) -- 
    ,prof_type varchar2(3) -- 业务种类
    ,license_deadline varchar2(12) -- 法定代表人或负责人证件有效期截止日
    ,acc_add varchar2(150) -- 网络商户登记网址
    ,acc_ip varchar2(75) -- 网络商户登记ip
    ,acc_icp_no varchar2(30) -- 网络商户icp备案/许可证号
    ,reg_amt varchar2(27) -- 注册资本金
    ,coo_state varchar2(3) -- 合作状态
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
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_direct_mchnt_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_direct_mchnt_inf is '直连商户表';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mchtserial is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcht_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcht_official_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcht_addr is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acq_bank is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.open_stlno is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.settle_bank_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contact is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contact_nick is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contact_job is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contact_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contact_fix is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.electrofax is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.install_contact is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.install_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.install_fix is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.busi_type_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.back_rate is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_mng is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.enable_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.enable_lmt_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.expired_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reg_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.opr_unit is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.sign_man is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.status is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.is_costfee is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.contract_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.press_card is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.press_card_dt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.addition_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.freeze is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.postcode is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.area_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.isrisk is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.apply_term is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.apply_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.dealwith is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.dealwith_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.dealwith_dsp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.finish is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.under_platform is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_rate2 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_rate_in is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_rate_out is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acct_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.origi_mcht_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.buss_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.buss_cd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.licence_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.spe_settle_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.allot_algo is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.allot_index is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.allot_ins is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.open_bank_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.exp_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.bus_lic_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.invo_open_bank is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.invo_acct is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.invo_acct_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.apply_prefer is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.brand is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reg_addr is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_crd is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_dbt is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.fee_bdb is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.trans_ctrl is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.apply_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.deal_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.filename is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reserve1 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reserve2 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reserve3 is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcht_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.conn_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acq_inst_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.mcc is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.licence_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.tax_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.bank_licence_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.director_nm is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.director_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.scale is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.clear_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.settle_type is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.oper_id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.create_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.id is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.rec_upd_ts is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.upd_oper is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.inspact_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.inspact_cycle is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.return_sta is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.train_date is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.train_cycle is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.exp_bank is '//用于拓展行';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.comm_email is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.comm_mobil is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.artif_certif_tp is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.manager_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.agr_br is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.net_tel is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.ztflag is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acct_chnl is '';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.prof_type is '业务种类';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.license_deadline is '法定代表人或负责人证件有效期截止日';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acc_add is '网络商户登记网址';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acc_ip is '网络商户登记ip';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.acc_icp_no is '网络商户icp备案/许可证号';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.reg_amt is '注册资本金';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.coo_state is '合作状态';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_direct_mchnt_inf.etl_timestamp is 'ETL处理时间戳';
