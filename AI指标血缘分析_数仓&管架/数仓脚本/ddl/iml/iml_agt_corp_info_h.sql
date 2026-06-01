/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_corp_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_corp_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_corp_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,agt_corp_id varchar2(100) -- 协议单位编号
    ,agt_corp_name varchar2(750) -- 协议单位名称
    ,agt_corp_abbr varchar2(750) -- 协议单位简称
    ,payfan_chn_id varchar2(100) -- 代付渠道编号
    ,agency_id varchar2(100) -- 代理商编号
    ,agt_corp_type_cd varchar2(30) -- 协议单位类型代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,bus_lics_id varchar2(100) -- 营业执照编号
    ,bus_lics_stop_valid_dt date -- 营业执照截止有效日期
    ,lp_name varchar2(750) -- 法人姓名
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,mobile_no varchar2(60) -- 手机号码
    ,e_mail varchar2(150) -- 电子邮箱
    ,cotas_name varchar2(750) -- 联系人名称
    ,cotas_cert_type_cd varchar2(30) -- 联系人证件类型代码
    ,cotas_cert_no varchar2(60) -- 联系人证件号码
    ,cotas_tel_num varchar2(60) -- 联系人电话号码
    ,zip_cd varchar2(90) -- 邮政编码
    ,cotas_addr varchar2(750) -- 联系人地址
    ,stl_acct_type_cd varchar2(30) -- 结算账户类型代码
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,stl_acct_name varchar2(750) -- 结算账户名称
    ,ghb_enter_acct_flg varchar2(10) -- 本行入账标志
    ,open_bank_no varchar2(60) -- 开户行行号
    ,open_bank_bank_name varchar2(750) -- 开户行行名称
    ,open_acct_addr varchar2(1500) -- 开户地址
    ,agt_corp_status_cd varchar2(30) -- 协议单位状态代码
    ,recvbl_acct_type_cd varchar2(30) -- 收款账户类型代码
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(750) -- 收款账户名称
    ,add_dt date -- 新增日期
    ,final_modif_dt date -- 最后修改日期
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,sys_idf varchar2(45) -- API系统标识
    ,adv_acct_type_cd varchar2(30) -- 垫资账户类型代码
    ,adv_acct_id varchar2(100) -- 垫资账户编号
    ,adv_acct_name varchar2(750) -- 垫资账户名称
    ,agt_corp_lmt number(30,2) -- 协议单位额度
    ,sig_lmt number(30,2) -- 单笔限额
    ,used_lmt number(30,2) -- 已使用额度
    ,payfan_second_lmt number(30,2) -- 代付还款额度
    ,adv_amt number(30,2) -- 垫资金额
    ,last_use_lmt number(30,2) -- 上次使用额度
    ,st_msg_advise_mobile_no varchar2(60) -- 短信通知手机号码
    ,st_msg_advise_name varchar2(750) -- 短信通知姓名
    ,valid_flg varchar2(10) -- 有效标志
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
grant select on ${iml_schema}.agt_corp_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_corp_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_corp_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_corp_info_h is '协议单位信息历史';
comment on column ${iml_schema}.agt_corp_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_corp_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_id is '协议单位编号';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_name is '协议单位名称';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_abbr is '协议单位简称';
comment on column ${iml_schema}.agt_corp_info_h.payfan_chn_id is '代付渠道编号';
comment on column ${iml_schema}.agt_corp_info_h.agency_id is '代理商编号';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_type_cd is '协议单位类型代码';
comment on column ${iml_schema}.agt_corp_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_corp_info_h.bus_lics_id is '营业执照编号';
comment on column ${iml_schema}.agt_corp_info_h.bus_lics_stop_valid_dt is '营业执照截止有效日期';
comment on column ${iml_schema}.agt_corp_info_h.lp_name is '法人姓名';
comment on column ${iml_schema}.agt_corp_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_corp_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_corp_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_corp_info_h.e_mail is '电子邮箱';
comment on column ${iml_schema}.agt_corp_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_corp_info_h.cotas_cert_type_cd is '联系人证件类型代码';
comment on column ${iml_schema}.agt_corp_info_h.cotas_cert_no is '联系人证件号码';
comment on column ${iml_schema}.agt_corp_info_h.cotas_tel_num is '联系人电话号码';
comment on column ${iml_schema}.agt_corp_info_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.agt_corp_info_h.cotas_addr is '联系人地址';
comment on column ${iml_schema}.agt_corp_info_h.stl_acct_type_cd is '结算账户类型代码';
comment on column ${iml_schema}.agt_corp_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_corp_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_corp_info_h.ghb_enter_acct_flg is '本行入账标志';
comment on column ${iml_schema}.agt_corp_info_h.open_bank_no is '开户行行号';
comment on column ${iml_schema}.agt_corp_info_h.open_bank_bank_name is '开户行行名称';
comment on column ${iml_schema}.agt_corp_info_h.open_acct_addr is '开户地址';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_status_cd is '协议单位状态代码';
comment on column ${iml_schema}.agt_corp_info_h.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.agt_corp_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_corp_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_corp_info_h.add_dt is '新增日期';
comment on column ${iml_schema}.agt_corp_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_corp_info_h.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.agt_corp_info_h.sys_idf is 'API系统标识';
comment on column ${iml_schema}.agt_corp_info_h.adv_acct_type_cd is '垫资账户类型代码';
comment on column ${iml_schema}.agt_corp_info_h.adv_acct_id is '垫资账户编号';
comment on column ${iml_schema}.agt_corp_info_h.adv_acct_name is '垫资账户名称';
comment on column ${iml_schema}.agt_corp_info_h.agt_corp_lmt is '协议单位额度';
comment on column ${iml_schema}.agt_corp_info_h.sig_lmt is '单笔限额';
comment on column ${iml_schema}.agt_corp_info_h.used_lmt is '已使用额度';
comment on column ${iml_schema}.agt_corp_info_h.payfan_second_lmt is '代付还款额度';
comment on column ${iml_schema}.agt_corp_info_h.adv_amt is '垫资金额';
comment on column ${iml_schema}.agt_corp_info_h.last_use_lmt is '上次使用额度';
comment on column ${iml_schema}.agt_corp_info_h.st_msg_advise_mobile_no is '短信通知手机号码';
comment on column ${iml_schema}.agt_corp_info_h.st_msg_advise_name is '短信通知姓名';
comment on column ${iml_schema}.agt_corp_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.agt_corp_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_corp_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_corp_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_corp_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_corp_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_corp_info_h.etl_timestamp is 'ETL处理时间戳';
