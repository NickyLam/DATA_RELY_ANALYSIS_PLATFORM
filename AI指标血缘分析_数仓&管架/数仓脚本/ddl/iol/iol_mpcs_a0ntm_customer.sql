/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_customer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_customer
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_customer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_customer(
    org varchar2(18) -- 机构号
    ,cust_id number(20,0) -- 客户编号
    ,id_no varchar2(45) -- 证件号码
    ,id_type varchar2(2) -- 证件类型
    ,title varchar2(2) -- 称谓
    ,name varchar2(120) -- 姓名
    ,gender varchar2(2) -- 性别
    ,birthday varchar2(15) -- 生日
    ,occupation varchar2(90) -- 职业
    ,bankmember_no varchar2(90) -- 本行员工号
    ,nationality varchar2(5) -- 国籍
    ,pr_of_country varchar2(2) -- 是否永久居住
    ,residency_country_cd varchar2(5) -- 永久居住地国家代码
    ,buser_field1 varchar2(90) -- 系统备用域1
    ,buser_field2 varchar2(90) -- 系统备用域2
    ,buser_field3 varchar2(90) -- 系统备用域3
    ,buser_field4 varchar2(300) -- 系统备用域4
    ,buser_field5 varchar2(90) -- 系统备用域5
    ,buser_field6 varchar2(90) -- 系统备用域6
    ,buser_field7 varchar2(90) -- 系统备用域7
    ,buser_field8 date -- 系统备用域8
    ,buser_field9 varchar2(90) -- 系统备用域9
    ,mobile_no varchar2(30) -- 移动电话
    ,buser_field10 varchar2(120) -- 系统备用域10
    ,emp_status varchar2(90) -- 就业状态
    ,nbr_of_dependents number(22) -- 抚养人数
    ,language_ind varchar2(6) -- 语言代码
    ,setup_date date -- 创建日期
    ,social_ins_amt number(19,6) -- 社保缴存金额
    ,drive_license_id varchar2(90) -- 驾驶证号码
    ,drive_lic_reg_date date -- 驾驶证登记日期
    ,obligate_question varchar2(120) -- 预留问题
    ,obligate_answer varchar2(120) -- 预留答案
    ,emp_stability varchar2(90) -- 工作稳定性
    ,corp_name varchar2(300) -- 公司名称
    ,user_code1 varchar2(90) -- 用户自定义代码1
    ,user_code2 varchar2(90) -- 用户自定义代码2
    ,user_code3 varchar2(90) -- 用户自定义代码3
    ,user_code4 varchar2(90) -- 用户自定义代码4
    ,user_code5 varchar2(90) -- 用户自定义代码5
    ,user_code6 varchar2(90) -- 用户自定义代码6
    ,user_date1 date -- 用户自定义日期1
    ,user_date2 date -- 用户自定义日期2
    ,user_date3 date -- 用户自定义日期3
    ,user_date4 date -- 用户自定义日期4
    ,user_date5 date -- 用户自定义日期5
    ,user_date6 date -- 用户自定义日期6
    ,user_number1 number(22) -- 用户自定义笔数1
    ,user_number2 number(22) -- 用户自定义笔数2
    ,user_number3 number(22) -- 用户自定义笔数3
    ,user_number4 number(22) -- 用户自定义笔数4
    ,user_number5 number(22) -- 用户自定义笔数5
    ,user_number6 number(22) -- 用户自定义笔数6
    ,user_field1 varchar2(90) -- 用户自定义域1
    ,user_field2 varchar2(90) -- 用户自定义域2
    ,user_field3 varchar2(90) -- 用户自定义域3
    ,user_field4 varchar2(90) -- 用户自定义域4
    ,user_field5 varchar2(90) -- 用户自定义域5
    ,user_field6 varchar2(90) -- 用户自定义域6
    ,user_amt1 number(19,6) -- 用户自定义金额1
    ,user_amt2 number(19,6) -- 用户自定义金额2
    ,user_amt3 number(19,6) -- 用户自定义金额3
    ,user_amt4 number(19,6) -- 用户自定义金额4
    ,user_amt5 number(19,6) -- 用户自定义金额5
    ,user_amt6 number(19,6) -- 昨日贷记卡承诺余额
    ,bank_customer_id varchar2(90) -- 行内统一用户号
    ,emb_name varchar2(90) -- 拼音名
    ,jpa_version number(22) -- 乐观锁版本号
    ,cust_limit_id number(20,0) -- 客户额度id
    ,last_modified_datetime date -- 修改时间
    ,buser_field21 varchar2(90) -- 系统备用域21
    ,buser_field22 varchar2(90) -- 系统备用域22
    ,surname varchar2(30) -- 姓氏
    ,created_datetime date -- 创建时间
    ,buser_field23 varchar2(90) -- 系统备用域24
    ,buser_field24 varchar2(90) -- 系统备用域24
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,openflag varchar2(2) -- 核心开户状态：0:未开户 1:已开户 2:开户失败
    ,cbscustno varchar2(18) -- 核心对应的客户id
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
grant select on ${iol_schema}.mpcs_a0ntm_customer to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_customer to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_customer to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_customer to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_customer is '';
comment on column ${iol_schema}.mpcs_a0ntm_customer.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.cust_id is '客户编号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.id_no is '证件号码';
comment on column ${iol_schema}.mpcs_a0ntm_customer.id_type is '证件类型';
comment on column ${iol_schema}.mpcs_a0ntm_customer.title is '称谓';
comment on column ${iol_schema}.mpcs_a0ntm_customer.name is '姓名';
comment on column ${iol_schema}.mpcs_a0ntm_customer.gender is '性别';
comment on column ${iol_schema}.mpcs_a0ntm_customer.birthday is '生日';
comment on column ${iol_schema}.mpcs_a0ntm_customer.occupation is '职业';
comment on column ${iol_schema}.mpcs_a0ntm_customer.bankmember_no is '本行员工号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.nationality is '国籍';
comment on column ${iol_schema}.mpcs_a0ntm_customer.pr_of_country is '是否永久居住';
comment on column ${iol_schema}.mpcs_a0ntm_customer.residency_country_cd is '永久居住地国家代码';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field1 is '系统备用域1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field2 is '系统备用域2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field3 is '系统备用域3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field4 is '系统备用域4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field5 is '系统备用域5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field6 is '系统备用域6';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field7 is '系统备用域7';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field8 is '系统备用域8';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field9 is '系统备用域9';
comment on column ${iol_schema}.mpcs_a0ntm_customer.mobile_no is '移动电话';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field10 is '系统备用域10';
comment on column ${iol_schema}.mpcs_a0ntm_customer.emp_status is '就业状态';
comment on column ${iol_schema}.mpcs_a0ntm_customer.nbr_of_dependents is '抚养人数';
comment on column ${iol_schema}.mpcs_a0ntm_customer.language_ind is '语言代码';
comment on column ${iol_schema}.mpcs_a0ntm_customer.setup_date is '创建日期';
comment on column ${iol_schema}.mpcs_a0ntm_customer.social_ins_amt is '社保缴存金额';
comment on column ${iol_schema}.mpcs_a0ntm_customer.drive_license_id is '驾驶证号码';
comment on column ${iol_schema}.mpcs_a0ntm_customer.drive_lic_reg_date is '驾驶证登记日期';
comment on column ${iol_schema}.mpcs_a0ntm_customer.obligate_question is '预留问题';
comment on column ${iol_schema}.mpcs_a0ntm_customer.obligate_answer is '预留答案';
comment on column ${iol_schema}.mpcs_a0ntm_customer.emp_stability is '工作稳定性';
comment on column ${iol_schema}.mpcs_a0ntm_customer.corp_name is '公司名称';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code1 is '用户自定义代码1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code2 is '用户自定义代码2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code3 is '用户自定义代码3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code4 is '用户自定义代码4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code5 is '用户自定义代码5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_code6 is '用户自定义代码6';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date1 is '用户自定义日期1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date2 is '用户自定义日期2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date3 is '用户自定义日期3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date4 is '用户自定义日期4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date5 is '用户自定义日期5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_date6 is '用户自定义日期6';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number1 is '用户自定义笔数1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number2 is '用户自定义笔数2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number3 is '用户自定义笔数3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number4 is '用户自定义笔数4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number5 is '用户自定义笔数5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_number6 is '用户自定义笔数6';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field1 is '用户自定义域1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field2 is '用户自定义域2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field3 is '用户自定义域3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field4 is '用户自定义域4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field5 is '用户自定义域5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_field6 is '用户自定义域6';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt1 is '用户自定义金额1';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt2 is '用户自定义金额2';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt3 is '用户自定义金额3';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt4 is '用户自定义金额4';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt5 is '用户自定义金额5';
comment on column ${iol_schema}.mpcs_a0ntm_customer.user_amt6 is '昨日贷记卡承诺余额';
comment on column ${iol_schema}.mpcs_a0ntm_customer.bank_customer_id is '行内统一用户号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.emb_name is '拼音名';
comment on column ${iol_schema}.mpcs_a0ntm_customer.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.cust_limit_id is '客户额度id';
comment on column ${iol_schema}.mpcs_a0ntm_customer.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field21 is '系统备用域21';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field22 is '系统备用域22';
comment on column ${iol_schema}.mpcs_a0ntm_customer.surname is '姓氏';
comment on column ${iol_schema}.mpcs_a0ntm_customer.created_datetime is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field23 is '系统备用域24';
comment on column ${iol_schema}.mpcs_a0ntm_customer.buser_field24 is '系统备用域24';
comment on column ${iol_schema}.mpcs_a0ntm_customer.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_customer.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_customer.openflag is '核心开户状态：0:未开户 1:已开户 2:开户失败';
comment on column ${iol_schema}.mpcs_a0ntm_customer.cbscustno is '核心对应的客户id';
comment on column ${iol_schema}.mpcs_a0ntm_customer.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_customer.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_customer.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_customer.etl_timestamp is 'ETL处理时间戳';
