/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_loan_customer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_loan_customer
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_loan_customer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_customer(
    cid number(22,0) -- 借款人ID
    ,loan_id number(22,0) -- 进件id
    ,code varchar2(4000) -- 借款人编码
    ,hand_input_name varchar2(4000) -- 用户手动输入的姓名
    ,cname varchar2(4000) -- 客户名称
    ,sex varchar2(4000) -- 性别
    ,age number(22,0) -- 年龄
    ,id_card_no varchar2(4000) -- 证件号码
    ,id_card_addr varchar2(4000) -- 身份证住址
    ,province_region varchar2(4000) -- 家庭住址的省市区,多级斜杠隔开
    ,home_addr varchar2(4000) -- 家庭住址（具体地址）
    ,telephone varchar2(4000) -- 手机号码
    ,marital_status varchar2(4000) -- 婚姻状况
    ,education varchar2(4000) -- 学历
    ,apply_balance number(38,8) -- 申请金额(元)
    ,apply_type varchar2(4000) -- 申请类型：person个人；company企业；
    ,repayment_period varchar2(4000) -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
    ,repayment_kind number(22,0) -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,location_addr varchar2(4000) -- 定位地址
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,isdel number(22,0) -- 删除标识
    ,remarks varchar2(4000) -- 备注
    ,lsxd_busi_type varchar2(4000) -- 零售信贷业务品种
    ,cust_no varchar2(4000) -- 核心客户号
    ,is_new_citizen varchar2(4000) -- 是否新市民 字典:shfzo
    ,industry_type varchar2(4000) -- 行业类别 字典:hytx一级大类
    ,is_retired_servicemen varchar2(4000) -- 是否退役军人 字典:shfzo
    ,emp_status varchar2(4000) -- 就业状况 字典:khjyzk
    ,start_employ_ment_year varchar2(4000) -- 开始任职年份
    ,borroweramount number(38,8) -- 借款人出资额
    ,borrower_holdratio varchar2(4000) -- 借款人控股比例
    ,work_hold number(22,0) -- 家庭工作人数
    ,edu_degree varchar2(4000) -- 最高学位 字典:khzgxw
    ,bank_credit_limit_amount number(38,8) -- 行内限额结果
    ,cust_type varchar2(4000) -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
    ,enterprise_name varchar2(4000) -- 企业名称
    ,enterprise_region varchar2(4000) -- 企业经营地址:省市区
    ,enterprise_address varchar2(4000) -- 企业经营地址:详细地址
    ,sign_cust_id varchar2(4000) -- 安心签用户ID
    ,occupation varchar2(4000) -- 职业
    ,address_code varchar2(4000) -- 户籍行政地址,格式是：/0000/0900/0090
    ,longitude_code varchar2(4000) -- 经度
    ,latitude_code varchar2(4000) -- 纬度
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
grant select on ${iol_schema}.hgls_loan_customer to ${iml_schema};
grant select on ${iol_schema}.hgls_loan_customer to ${icl_schema};
grant select on ${iol_schema}.hgls_loan_customer to ${idl_schema};
grant select on ${iol_schema}.hgls_loan_customer to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_loan_customer is '借款人主表';
comment on column ${iol_schema}.hgls_loan_customer.cid is '借款人ID';
comment on column ${iol_schema}.hgls_loan_customer.loan_id is '进件id';
comment on column ${iol_schema}.hgls_loan_customer.code is '借款人编码';
comment on column ${iol_schema}.hgls_loan_customer.hand_input_name is '用户手动输入的姓名';
comment on column ${iol_schema}.hgls_loan_customer.cname is '客户名称';
comment on column ${iol_schema}.hgls_loan_customer.sex is '性别';
comment on column ${iol_schema}.hgls_loan_customer.age is '年龄';
comment on column ${iol_schema}.hgls_loan_customer.id_card_no is '证件号码';
comment on column ${iol_schema}.hgls_loan_customer.id_card_addr is '身份证住址';
comment on column ${iol_schema}.hgls_loan_customer.province_region is '家庭住址的省市区,多级斜杠隔开';
comment on column ${iol_schema}.hgls_loan_customer.home_addr is '家庭住址（具体地址）';
comment on column ${iol_schema}.hgls_loan_customer.telephone is '手机号码';
comment on column ${iol_schema}.hgls_loan_customer.marital_status is '婚姻状况';
comment on column ${iol_schema}.hgls_loan_customer.education is '学历';
comment on column ${iol_schema}.hgls_loan_customer.apply_balance is '申请金额(元)';
comment on column ${iol_schema}.hgls_loan_customer.apply_type is '申请类型：person个人；company企业；';
comment on column ${iol_schema}.hgls_loan_customer.repayment_period is '还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期';
comment on column ${iol_schema}.hgls_loan_customer.repayment_kind is '还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs';
comment on column ${iol_schema}.hgls_loan_customer.location_addr is '定位地址';
comment on column ${iol_schema}.hgls_loan_customer.create_date is '申请日期';
comment on column ${iol_schema}.hgls_loan_customer.update_date is '更新时间';
comment on column ${iol_schema}.hgls_loan_customer.isdel is '删除标识';
comment on column ${iol_schema}.hgls_loan_customer.remarks is '备注';
comment on column ${iol_schema}.hgls_loan_customer.lsxd_busi_type is '零售信贷业务品种';
comment on column ${iol_schema}.hgls_loan_customer.cust_no is '核心客户号';
comment on column ${iol_schema}.hgls_loan_customer.is_new_citizen is '是否新市民 字典:shfzo';
comment on column ${iol_schema}.hgls_loan_customer.industry_type is '行业类别 字典:hytx一级大类';
comment on column ${iol_schema}.hgls_loan_customer.is_retired_servicemen is '是否退役军人 字典:shfzo';
comment on column ${iol_schema}.hgls_loan_customer.emp_status is '就业状况 字典:khjyzk';
comment on column ${iol_schema}.hgls_loan_customer.start_employ_ment_year is '开始任职年份';
comment on column ${iol_schema}.hgls_loan_customer.borroweramount is '借款人出资额';
comment on column ${iol_schema}.hgls_loan_customer.borrower_holdratio is '借款人控股比例';
comment on column ${iol_schema}.hgls_loan_customer.work_hold is '家庭工作人数';
comment on column ${iol_schema}.hgls_loan_customer.edu_degree is '最高学位 字典:khzgxw';
comment on column ${iol_schema}.hgls_loan_customer.bank_credit_limit_amount is '行内限额结果';
comment on column ${iol_schema}.hgls_loan_customer.cust_type is '客户类型 字典:xwdkhlx 1:经营户 2:工薪族';
comment on column ${iol_schema}.hgls_loan_customer.enterprise_name is '企业名称';
comment on column ${iol_schema}.hgls_loan_customer.enterprise_region is '企业经营地址:省市区';
comment on column ${iol_schema}.hgls_loan_customer.enterprise_address is '企业经营地址:详细地址';
comment on column ${iol_schema}.hgls_loan_customer.sign_cust_id is '安心签用户ID';
comment on column ${iol_schema}.hgls_loan_customer.occupation is '职业';
comment on column ${iol_schema}.hgls_loan_customer.address_code is '户籍行政地址,格式是：/0000/0900/0090';
comment on column ${iol_schema}.hgls_loan_customer.longitude_code is '经度';
comment on column ${iol_schema}.hgls_loan_customer.latitude_code is '纬度';
comment on column ${iol_schema}.hgls_loan_customer.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_loan_customer.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_loan_customer.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_loan_customer.etl_timestamp is 'ETL处理时间戳';
