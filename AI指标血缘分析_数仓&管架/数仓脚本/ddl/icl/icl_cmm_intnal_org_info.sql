/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_intnal_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_intnal_org_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_intnal_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_intnal_org_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,org_id varchar2(60) -- 机构编号
    ,org_name varchar2(300) -- 机构名称
    ,org_abbr varchar2(200) -- 机构简称
    ,org_en_name varchar2(200) -- 机构英文名称
    ,org_en_abbr varchar2(200) -- 机构英文简称
    ,princ_emply_id varchar2(60) -- 负责人员工编号
    ,cbrc_fin_inst_id varchar2(60) -- 银监会金融机构编号
    ,unionpay_fin_inst_id varchar2(60) -- 银联金融机构编号
    ,fin_inst_idf_code varchar2(90) -- 金融机构标识码
    ,bus_lics_num varchar2(60) -- 营业执照号码
    ,fin_lics_num varchar2(60) -- 金融许可证号
    ,tax_regi_cert_num varchar2(100) -- 税务登记证号
    ,pbc_pay_bank_no varchar2(60) -- 人行支付行号
    ,pay_sys_bank_no varchar2(100) -- 支付系统银行行号
    ,fin_inst_code varchar2(90) -- 人行金融机构编码
    ,hq_org_id varchar2(60) -- 总行机构编号
    ,hq_org_name varchar2(300) -- 总行机构名称
    ,brch_id varchar2(60) -- 分行编号
    ,brch_name varchar2(300) -- 分行名称
    ,subrch_id varchar2(60) -- 支行编号
    ,subrch_name varchar2(300) -- 支行名称
    ,org_type_cd varchar2(10) -- 机构类型代码
    ,org_lev_cd varchar2(10) -- 机构级别代码
    ,org_hibchy_cd varchar2(30) -- 机构层级代码
    ,org_status_cd varchar2(10) -- 机构状态代码
    ,orgnz_cd varchar2(30) -- 组织机构代码
    ,bus_status_cd varchar2(10) -- 营业状态代码
    ,bus_org_flg varchar2(10) -- 营业机构标志
    ,enty_org_flg varchar2(10) -- 实体机构标志
    ,accti_org_flg varchar2(10) -- 核算机构标志
    ,admin_org_flg varchar2(10) -- 行政机构标志
    ,acct_instit_flg varchar2(10) -- 账务机构标志
    ,dtl_org_flg varchar2(10) -- 明细机构标志
    ,vtual_accti_org_flg varchar2(10) -- 虚拟核算机构标志
    ,free_trade_rg_flg varchar2(10) -- 自由贸易区标志
	,retl_execu_org_flg	varchar2(10) -- 零售管户机构标志
    ,admin_super_org_id varchar2(60) -- 行政上级机构编号
    ,acct_super_org_id varchar2(60) -- 账务上级机构编号
    ,accti_super_org_id varchar2(60) -- 核算上级机构编号
    ,rept_super_org_id varchar2(60) -- 报表上级机构编号
    ,func_org_id varchar2(60) -- 职能机构编号
    ,func_dept_id varchar2(60) -- 职能部门编号
    ,swiftcode varchar2(100) -- SWIFTCODE
    ,cty_rg_cd varchar2(10) -- 国家和地区代码
    ,prov_cd varchar2(10) -- 省代码
    ,city_cd varchar2(10) -- 市代码
    ,county_cd varchar2(10) -- 县代码
    ,phys_addr varchar2(750) -- 物理地址
    ,ddd_area_cd varchar2(10) -- 国内长途区号
    ,idd_area_cd varchar2(10) -- 国际长途区号
    ,phone varchar2(90) -- 联系电话
    ,ext_num varchar2(100) -- 分机号
    ,serv_tel varchar2(100) -- 服务电话
    ,e_mail varchar2(200) -- 电子邮箱
    ,url varchar2(200) -- 网址
    ,zip_cd varchar2(60) -- 邮政编码
    ,pbc_belong_city_cd varchar2(30) -- 人行所属城市代码
    ,pbc_belong_city varchar2(300) -- 人行所属城市
    ,org_found_dt date -- 机构成立日期
    ,org_revo_dt date -- 机构撤销日期
    ,org_start_bus_tm varchar2(6) -- 机构开始营业时间
    ,org_end_bus_tm varchar2(6) -- 机构结束营业时间
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_intnal_org_info to ${idl_schema};
grant select on ${icl_schema}.cmm_intnal_org_info to ${iel_schema};
grant select on ${icl_schema}.cmm_intnal_org_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_intnal_org_info is '内部机构信息表';
comment on column ${icl_schema}.cmm_intnal_org_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_intnal_org_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_intnal_org_info.org_id is '机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.org_name is '机构名称';
comment on column ${icl_schema}.cmm_intnal_org_info.org_abbr is '机构简称';
comment on column ${icl_schema}.cmm_intnal_org_info.org_en_name is '机构英文名称';
comment on column ${icl_schema}.cmm_intnal_org_info.org_en_abbr is '机构英文简称';
comment on column ${icl_schema}.cmm_intnal_org_info.princ_emply_id is '负责人员工编号';
comment on column ${icl_schema}.cmm_intnal_org_info.cbrc_fin_inst_id is '银监会金融机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.unionpay_fin_inst_id is '银联金融机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.fin_inst_idf_code is '金融机构标识码';
comment on column ${icl_schema}.cmm_intnal_org_info.bus_lics_num is '营业执照号码';
comment on column ${icl_schema}.cmm_intnal_org_info.fin_lics_num is '金融许可证号';
comment on column ${icl_schema}.cmm_intnal_org_info.tax_regi_cert_num is '税务登记证号';
comment on column ${icl_schema}.cmm_intnal_org_info.pbc_pay_bank_no is '人行支付行号';
comment on column ${icl_schema}.cmm_intnal_org_info.pay_sys_bank_no is '支付系统银行行号';
comment on column ${icl_schema}.cmm_intnal_org_info.fin_inst_code is '人行金融机构编码';
comment on column ${icl_schema}.cmm_intnal_org_info.hq_org_id is '总行机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.hq_org_name is '总行机构名称';
comment on column ${icl_schema}.cmm_intnal_org_info.brch_id is '分行编号';
comment on column ${icl_schema}.cmm_intnal_org_info.brch_name is '分行名称';
comment on column ${icl_schema}.cmm_intnal_org_info.subrch_id is '支行编号';
comment on column ${icl_schema}.cmm_intnal_org_info.subrch_name is '支行名称';
comment on column ${icl_schema}.cmm_intnal_org_info.org_type_cd is '机构类型代码';
comment on column ${icl_schema}.cmm_intnal_org_info.org_lev_cd is '机构级别代码';
comment on column ${icl_schema}.cmm_intnal_org_info.org_hibchy_cd is '机构层级代码';
comment on column ${icl_schema}.cmm_intnal_org_info.org_status_cd is '机构状态代码';
comment on column ${icl_schema}.cmm_intnal_org_info.orgnz_cd is '组织机构代码';
comment on column ${icl_schema}.cmm_intnal_org_info.bus_status_cd is '营业状态代码';
comment on column ${icl_schema}.cmm_intnal_org_info.bus_org_flg is '营业机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.enty_org_flg is '实体机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.accti_org_flg is '核算机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.admin_org_flg is '行政机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.acct_instit_flg is '账务机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.dtl_org_flg is '明细机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.vtual_accti_org_flg is '虚拟核算机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.free_trade_rg_flg is '自由贸易区标志';
comment on column ${icl_schema}.cmm_intnal_org_info.retl_execu_org_flg is '零售管户机构标志';
comment on column ${icl_schema}.cmm_intnal_org_info.admin_super_org_id is '行政上级机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.acct_super_org_id is '账务上级机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.accti_super_org_id is '核算上级机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.rept_super_org_id is '报表上级机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.func_org_id is '职能机构编号';
comment on column ${icl_schema}.cmm_intnal_org_info.func_dept_id is '职能部门编号';
comment on column ${icl_schema}.cmm_intnal_org_info.swiftcode is 'SWIFTCODE';
comment on column ${icl_schema}.cmm_intnal_org_info.cty_rg_cd is '国家和地区代码';
comment on column ${icl_schema}.cmm_intnal_org_info.prov_cd is '省代码';
comment on column ${icl_schema}.cmm_intnal_org_info.city_cd is '市代码';
comment on column ${icl_schema}.cmm_intnal_org_info.county_cd is '县代码';
comment on column ${icl_schema}.cmm_intnal_org_info.phys_addr is '物理地址';
comment on column ${icl_schema}.cmm_intnal_org_info.ddd_area_cd is '国内长途区号';
comment on column ${icl_schema}.cmm_intnal_org_info.idd_area_cd is '国际长途区号';
comment on column ${icl_schema}.cmm_intnal_org_info.phone is '联系电话';
comment on column ${icl_schema}.cmm_intnal_org_info.ext_num is '分机号';
comment on column ${icl_schema}.cmm_intnal_org_info.serv_tel is '服务电话';
comment on column ${icl_schema}.cmm_intnal_org_info.e_mail is '电子邮箱';
comment on column ${icl_schema}.cmm_intnal_org_info.url is '网址';
comment on column ${icl_schema}.cmm_intnal_org_info.zip_cd is '邮政编码';
comment on column ${icl_schema}.cmm_intnal_org_info.pbc_belong_city_cd is '人行所属城市代码';
comment on column ${icl_schema}.cmm_intnal_org_info.pbc_belong_city is '人行所属城市';
comment on column ${icl_schema}.cmm_intnal_org_info.org_found_dt is '机构成立日期';
comment on column ${icl_schema}.cmm_intnal_org_info.org_revo_dt is '机构撤销日期';
comment on column ${icl_schema}.cmm_intnal_org_info.org_start_bus_tm is '机构开始营业时间';
comment on column ${icl_schema}.cmm_intnal_org_info.org_end_bus_tm is '机构结束营业时间';
comment on column ${icl_schema}.cmm_intnal_org_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_intnal_org_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_intnal_org_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_intnal_org_info.etl_timestamp is 'ETL处理时间戳';
