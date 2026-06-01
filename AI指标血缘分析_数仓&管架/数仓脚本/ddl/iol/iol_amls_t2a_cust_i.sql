/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_cust_i
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_cust_i
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_cust_i purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_cust_i(
    cust_id varchar2(48) -- 客户编号
    ,org_id varchar2(24) -- 归属机构编号
    ,create_dt date -- 建立日期
    ,cust_name varchar2(768) -- 客户名称
    ,cust_en_name varchar2(768) -- 客户英文名称
    ,cust_sts varchar2(2) -- 客户状态（参见[字典:aml0078]）
    ,cust_type varchar2(2) -- 客户类型（参见[字典:aml0030]）
    ,aml_cust_type varchar2(3) -- aml客户类型（参见[字典:aml0081]）
    ,pbc_cust_type varchar2(3) -- pbc客户类型（参见[字典:aml0043]）
    ,pbc_ocp varchar2(48) -- pbc职业分类
    ,s_ocp varchar2(96) -- 源系统职业分类
    ,cust_nat varchar2(75) -- 国籍
    ,cust_area varchar2(9) -- 地区代码
    ,cert_type varchar2(72) -- 证件类型
    ,s_cert_type varchar2(72) -- 源系统证件类型
    ,cert_no varchar2(192) -- 证件号码
    ,cert_valid_dt date -- 证件生效日期
    ,cert_invalid_dt date -- 证件失效日期
    ,cert_addr varchar2(768) -- 证件地址
    ,home_addr varchar2(768) -- 家庭地址
    ,office_addr varchar2(3375) -- 办公地址
    ,office_tel varchar2(96) -- 办公电话
    ,home_tel varchar2(96) -- 家庭电话
    ,mobile_phone varchar2(96) -- 移动电话
    ,website varchar2(768) -- 网址
    ,email varchar2(768) -- email地址
    ,birth_dt date -- 出生日期
    ,edu_lvl varchar2(2) -- 最高学历（参见[字典:aml0082]）
    ,dgr_lvl varchar2(2) -- 最高学位（参见[字典:aml0083]）
    ,gender varchar2(2) -- 性别（参见[字典:aml0084]）
    ,duty varchar2(6) -- 职务（参见[字典:aml0085]）
    ,indus varchar2(30) -- 行业
    ,mgr_id varchar2(150) -- 客户经理编号
    ,mgr_name varchar2(144) -- 客户经理名称
    ,is_staff varchar2(2) -- 是否本行员工（参见[字典:aml0086]）
    ,staff_id varchar2(150) -- 员工编号
    ,nation_cd varchar2(5) -- 民族编码
    ,unit_name varchar2(300) -- 工作单位名称
    ,unit_addr varchar2(3375) -- 工作单位地址
    ,unit_prop varchar2(6) -- 工作单位性质
    ,income_amt number(30,4) -- 收入金额
    ,income_curr_cd varchar2(5) -- 收入币种
    ,rsrv_01 varchar2(48) -- 备用字段1---放置的是cif潜在客户字段码值
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,rsrv_04 varchar2(96) -- 备用字段4
    ,is_ebank varchar2(2) -- 是否网银客户(0:否,1:是)
    ,is_loan varchar2(2) -- 是否贷款客户(0:否,1:是)
    ,create_channel varchar2(75) -- 客户创建渠道
    ,is_free_trade varchar2(2) -- 是否自贸区客户(0:否,1:是)
    ,remarks varchar2(768) -- 备注
    ,close_dt varchar2(12) -- 客户号销号日期
    ,is_pos varchar2(2) -- 是否我行pos客户
    ,position varchar2(15) -- 岗位
    ,oth_cert_type varchar2(192) -- 其他证件类型
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
grant select on ${iol_schema}.amls_t2a_cust_i to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_cust_i to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_cust_i to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_cust_i to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_cust_i is 't2a_对私客户信息';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_cust_i.org_id is '归属机构编号';
comment on column ${iol_schema}.amls_t2a_cust_i.create_dt is '建立日期';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_en_name is '客户英文名称';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_sts is '客户状态（参见[字典:aml0078]）';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_type is '客户类型（参见[字典:aml0030]）';
comment on column ${iol_schema}.amls_t2a_cust_i.aml_cust_type is 'aml客户类型（参见[字典:aml0081]）';
comment on column ${iol_schema}.amls_t2a_cust_i.pbc_cust_type is 'pbc客户类型（参见[字典:aml0043]）';
comment on column ${iol_schema}.amls_t2a_cust_i.pbc_ocp is 'pbc职业分类';
comment on column ${iol_schema}.amls_t2a_cust_i.s_ocp is '源系统职业分类';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_nat is '国籍';
comment on column ${iol_schema}.amls_t2a_cust_i.cust_area is '地区代码';
comment on column ${iol_schema}.amls_t2a_cust_i.cert_type is '证件类型';
comment on column ${iol_schema}.amls_t2a_cust_i.s_cert_type is '源系统证件类型';
comment on column ${iol_schema}.amls_t2a_cust_i.cert_no is '证件号码';
comment on column ${iol_schema}.amls_t2a_cust_i.cert_valid_dt is '证件生效日期';
comment on column ${iol_schema}.amls_t2a_cust_i.cert_invalid_dt is '证件失效日期';
comment on column ${iol_schema}.amls_t2a_cust_i.cert_addr is '证件地址';
comment on column ${iol_schema}.amls_t2a_cust_i.home_addr is '家庭地址';
comment on column ${iol_schema}.amls_t2a_cust_i.office_addr is '办公地址';
comment on column ${iol_schema}.amls_t2a_cust_i.office_tel is '办公电话';
comment on column ${iol_schema}.amls_t2a_cust_i.home_tel is '家庭电话';
comment on column ${iol_schema}.amls_t2a_cust_i.mobile_phone is '移动电话';
comment on column ${iol_schema}.amls_t2a_cust_i.website is '网址';
comment on column ${iol_schema}.amls_t2a_cust_i.email is 'email地址';
comment on column ${iol_schema}.amls_t2a_cust_i.birth_dt is '出生日期';
comment on column ${iol_schema}.amls_t2a_cust_i.edu_lvl is '最高学历（参见[字典:aml0082]）';
comment on column ${iol_schema}.amls_t2a_cust_i.dgr_lvl is '最高学位（参见[字典:aml0083]）';
comment on column ${iol_schema}.amls_t2a_cust_i.gender is '性别（参见[字典:aml0084]）';
comment on column ${iol_schema}.amls_t2a_cust_i.duty is '职务（参见[字典:aml0085]）';
comment on column ${iol_schema}.amls_t2a_cust_i.indus is '行业';
comment on column ${iol_schema}.amls_t2a_cust_i.mgr_id is '客户经理编号';
comment on column ${iol_schema}.amls_t2a_cust_i.mgr_name is '客户经理名称';
comment on column ${iol_schema}.amls_t2a_cust_i.is_staff is '是否本行员工（参见[字典:aml0086]）';
comment on column ${iol_schema}.amls_t2a_cust_i.staff_id is '员工编号';
comment on column ${iol_schema}.amls_t2a_cust_i.nation_cd is '民族编码';
comment on column ${iol_schema}.amls_t2a_cust_i.unit_name is '工作单位名称';
comment on column ${iol_schema}.amls_t2a_cust_i.unit_addr is '工作单位地址';
comment on column ${iol_schema}.amls_t2a_cust_i.unit_prop is '工作单位性质';
comment on column ${iol_schema}.amls_t2a_cust_i.income_amt is '收入金额';
comment on column ${iol_schema}.amls_t2a_cust_i.income_curr_cd is '收入币种';
comment on column ${iol_schema}.amls_t2a_cust_i.rsrv_01 is '备用字段1---放置的是cif潜在客户字段码值';
comment on column ${iol_schema}.amls_t2a_cust_i.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_cust_i.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_cust_i.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_cust_i.is_ebank is '是否网银客户(0:否,1:是)';
comment on column ${iol_schema}.amls_t2a_cust_i.is_loan is '是否贷款客户(0:否,1:是)';
comment on column ${iol_schema}.amls_t2a_cust_i.create_channel is '客户创建渠道';
comment on column ${iol_schema}.amls_t2a_cust_i.is_free_trade is '是否自贸区客户(0:否,1:是)';
comment on column ${iol_schema}.amls_t2a_cust_i.remarks is '备注';
comment on column ${iol_schema}.amls_t2a_cust_i.close_dt is '客户号销号日期';
comment on column ${iol_schema}.amls_t2a_cust_i.is_pos is '是否我行pos客户';
comment on column ${iol_schema}.amls_t2a_cust_i.position is '岗位';
comment on column ${iol_schema}.amls_t2a_cust_i.oth_cert_type is '其他证件类型';
comment on column ${iol_schema}.amls_t2a_cust_i.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2a_cust_i.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2a_cust_i.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2a_cust_i.etl_timestamp is 'ETL处理时间戳';
