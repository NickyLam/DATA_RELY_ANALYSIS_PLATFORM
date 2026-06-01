/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_customer
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.hgls_loan_customer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_customer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_customer_op purge;
drop table ${iol_schema}.hgls_loan_customer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_customer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_customer where 0=1;

create table ${iol_schema}.hgls_loan_customer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_customer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_customer_cl(
            cid -- 借款人ID
            ,loan_id -- 进件id
            ,code -- 借款人编码
            ,hand_input_name -- 用户手动输入的姓名
            ,cname -- 客户名称
            ,sex -- 性别
            ,age -- 年龄
            ,id_card_no -- 证件号码
            ,id_card_addr -- 身份证住址
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,home_addr -- 家庭住址（具体地址）
            ,telephone -- 手机号码
            ,marital_status -- 婚姻状况
            ,education -- 学历
            ,apply_balance -- 申请金额(元)
            ,apply_type -- 申请类型：person个人；company企业；
            ,repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,location_addr -- 定位地址
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,remarks -- 备注
            ,lsxd_busi_type -- 零售信贷业务品种
            ,cust_no -- 核心客户号
            ,is_new_citizen -- 是否新市民 字典:shfzo
            ,industry_type -- 行业类别 字典:hytx一级大类
            ,is_retired_servicemen -- 是否退役军人 字典:shfzo
            ,emp_status -- 就业状况 字典:khjyzk
            ,start_employ_ment_year -- 开始任职年份
            ,borroweramount -- 借款人出资额
            ,borrower_holdratio -- 借款人控股比例
            ,work_hold -- 家庭工作人数
            ,edu_degree -- 最高学位 字典:khzgxw
            ,bank_credit_limit_amount -- 行内限额结果
            ,cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
            ,enterprise_name -- 企业名称
            ,enterprise_region -- 企业经营地址:省市区
            ,enterprise_address -- 企业经营地址:详细地址
            ,sign_cust_id -- 安心签用户ID
            ,occupation -- 职业
            ,address_code -- 户籍行政地址,格式是：/0000/0900/0090
            ,longitude_code -- 经度
            ,latitude_code -- 纬度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_customer_op(
            cid -- 借款人ID
            ,loan_id -- 进件id
            ,code -- 借款人编码
            ,hand_input_name -- 用户手动输入的姓名
            ,cname -- 客户名称
            ,sex -- 性别
            ,age -- 年龄
            ,id_card_no -- 证件号码
            ,id_card_addr -- 身份证住址
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,home_addr -- 家庭住址（具体地址）
            ,telephone -- 手机号码
            ,marital_status -- 婚姻状况
            ,education -- 学历
            ,apply_balance -- 申请金额(元)
            ,apply_type -- 申请类型：person个人；company企业；
            ,repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,location_addr -- 定位地址
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,remarks -- 备注
            ,lsxd_busi_type -- 零售信贷业务品种
            ,cust_no -- 核心客户号
            ,is_new_citizen -- 是否新市民 字典:shfzo
            ,industry_type -- 行业类别 字典:hytx一级大类
            ,is_retired_servicemen -- 是否退役军人 字典:shfzo
            ,emp_status -- 就业状况 字典:khjyzk
            ,start_employ_ment_year -- 开始任职年份
            ,borroweramount -- 借款人出资额
            ,borrower_holdratio -- 借款人控股比例
            ,work_hold -- 家庭工作人数
            ,edu_degree -- 最高学位 字典:khzgxw
            ,bank_credit_limit_amount -- 行内限额结果
            ,cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
            ,enterprise_name -- 企业名称
            ,enterprise_region -- 企业经营地址:省市区
            ,enterprise_address -- 企业经营地址:详细地址
            ,sign_cust_id -- 安心签用户ID
            ,occupation -- 职业
            ,address_code -- 户籍行政地址,格式是：/0000/0900/0090
            ,longitude_code -- 经度
            ,latitude_code -- 纬度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cid, o.cid) as cid -- 借款人ID
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件id
    ,nvl(n.code, o.code) as code -- 借款人编码
    ,nvl(n.hand_input_name, o.hand_input_name) as hand_input_name -- 用户手动输入的姓名
    ,nvl(n.cname, o.cname) as cname -- 客户名称
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.id_card_no, o.id_card_no) as id_card_no -- 证件号码
    ,nvl(n.id_card_addr, o.id_card_addr) as id_card_addr -- 身份证住址
    ,nvl(n.province_region, o.province_region) as province_region -- 家庭住址的省市区,多级斜杠隔开
    ,nvl(n.home_addr, o.home_addr) as home_addr -- 家庭住址（具体地址）
    ,nvl(n.telephone, o.telephone) as telephone -- 手机号码
    ,nvl(n.marital_status, o.marital_status) as marital_status -- 婚姻状况
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.apply_balance, o.apply_balance) as apply_balance -- 申请金额(元)
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 申请类型：person个人；company企业；
    ,nvl(n.repayment_period, o.repayment_period) as repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
    ,nvl(n.repayment_kind, o.repayment_kind) as repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,nvl(n.location_addr, o.location_addr) as location_addr -- 定位地址
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.isdel, o.isdel) as isdel -- 删除标识
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.lsxd_busi_type, o.lsxd_busi_type) as lsxd_busi_type -- 零售信贷业务品种
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 核心客户号
    ,nvl(n.is_new_citizen, o.is_new_citizen) as is_new_citizen -- 是否新市民 字典:shfzo
    ,nvl(n.industry_type, o.industry_type) as industry_type -- 行业类别 字典:hytx一级大类
    ,nvl(n.is_retired_servicemen, o.is_retired_servicemen) as is_retired_servicemen -- 是否退役军人 字典:shfzo
    ,nvl(n.emp_status, o.emp_status) as emp_status -- 就业状况 字典:khjyzk
    ,nvl(n.start_employ_ment_year, o.start_employ_ment_year) as start_employ_ment_year -- 开始任职年份
    ,nvl(n.borroweramount, o.borroweramount) as borroweramount -- 借款人出资额
    ,nvl(n.borrower_holdratio, o.borrower_holdratio) as borrower_holdratio -- 借款人控股比例
    ,nvl(n.work_hold, o.work_hold) as work_hold -- 家庭工作人数
    ,nvl(n.edu_degree, o.edu_degree) as edu_degree -- 最高学位 字典:khzgxw
    ,nvl(n.bank_credit_limit_amount, o.bank_credit_limit_amount) as bank_credit_limit_amount -- 行内限额结果
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
    ,nvl(n.enterprise_name, o.enterprise_name) as enterprise_name -- 企业名称
    ,nvl(n.enterprise_region, o.enterprise_region) as enterprise_region -- 企业经营地址:省市区
    ,nvl(n.enterprise_address, o.enterprise_address) as enterprise_address -- 企业经营地址:详细地址
    ,nvl(n.sign_cust_id, o.sign_cust_id) as sign_cust_id -- 安心签用户ID
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.address_code, o.address_code) as address_code -- 户籍行政地址,格式是：/0000/0900/0090
    ,nvl(n.longitude_code, o.longitude_code) as longitude_code -- 经度
    ,nvl(n.latitude_code, o.latitude_code) as latitude_code -- 纬度
    ,case when
            n.cid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_loan_customer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_customer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cid = n.cid
where (
        o.cid is null
    )
    or (
        n.cid is null
    )
    or (
        o.loan_id <> n.loan_id
        or o.code <> n.code
        or o.hand_input_name <> n.hand_input_name
        or o.cname <> n.cname
        or o.sex <> n.sex
        or o.age <> n.age
        or o.id_card_no <> n.id_card_no
        or o.id_card_addr <> n.id_card_addr
        or o.province_region <> n.province_region
        or o.home_addr <> n.home_addr
        or o.telephone <> n.telephone
        or o.marital_status <> n.marital_status
        or o.education <> n.education
        or o.apply_balance <> n.apply_balance
        or o.apply_type <> n.apply_type
        or o.repayment_period <> n.repayment_period
        or o.repayment_kind <> n.repayment_kind
        or o.location_addr <> n.location_addr
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.isdel <> n.isdel
        or o.remarks <> n.remarks
        or o.lsxd_busi_type <> n.lsxd_busi_type
        or o.cust_no <> n.cust_no
        or o.is_new_citizen <> n.is_new_citizen
        or o.industry_type <> n.industry_type
        or o.is_retired_servicemen <> n.is_retired_servicemen
        or o.emp_status <> n.emp_status
        or o.start_employ_ment_year <> n.start_employ_ment_year
        or o.borroweramount <> n.borroweramount
        or o.borrower_holdratio <> n.borrower_holdratio
        or o.work_hold <> n.work_hold
        or o.edu_degree <> n.edu_degree
        or o.bank_credit_limit_amount <> n.bank_credit_limit_amount
        or o.cust_type <> n.cust_type
        or o.enterprise_name <> n.enterprise_name
        or o.enterprise_region <> n.enterprise_region
        or o.enterprise_address <> n.enterprise_address
        or o.sign_cust_id <> n.sign_cust_id
        or o.occupation <> n.occupation
        or o.address_code <> n.address_code
        or o.longitude_code <> n.longitude_code
        or o.latitude_code <> n.latitude_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_customer_cl(
            cid -- 借款人ID
            ,loan_id -- 进件id
            ,code -- 借款人编码
            ,hand_input_name -- 用户手动输入的姓名
            ,cname -- 客户名称
            ,sex -- 性别
            ,age -- 年龄
            ,id_card_no -- 证件号码
            ,id_card_addr -- 身份证住址
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,home_addr -- 家庭住址（具体地址）
            ,telephone -- 手机号码
            ,marital_status -- 婚姻状况
            ,education -- 学历
            ,apply_balance -- 申请金额(元)
            ,apply_type -- 申请类型：person个人；company企业；
            ,repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,location_addr -- 定位地址
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,remarks -- 备注
            ,lsxd_busi_type -- 零售信贷业务品种
            ,cust_no -- 核心客户号
            ,is_new_citizen -- 是否新市民 字典:shfzo
            ,industry_type -- 行业类别 字典:hytx一级大类
            ,is_retired_servicemen -- 是否退役军人 字典:shfzo
            ,emp_status -- 就业状况 字典:khjyzk
            ,start_employ_ment_year -- 开始任职年份
            ,borroweramount -- 借款人出资额
            ,borrower_holdratio -- 借款人控股比例
            ,work_hold -- 家庭工作人数
            ,edu_degree -- 最高学位 字典:khzgxw
            ,bank_credit_limit_amount -- 行内限额结果
            ,cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
            ,enterprise_name -- 企业名称
            ,enterprise_region -- 企业经营地址:省市区
            ,enterprise_address -- 企业经营地址:详细地址
            ,sign_cust_id -- 安心签用户ID
            ,occupation -- 职业
            ,address_code -- 户籍行政地址,格式是：/0000/0900/0090
            ,longitude_code -- 经度
            ,latitude_code -- 纬度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_customer_op(
            cid -- 借款人ID
            ,loan_id -- 进件id
            ,code -- 借款人编码
            ,hand_input_name -- 用户手动输入的姓名
            ,cname -- 客户名称
            ,sex -- 性别
            ,age -- 年龄
            ,id_card_no -- 证件号码
            ,id_card_addr -- 身份证住址
            ,province_region -- 家庭住址的省市区,多级斜杠隔开
            ,home_addr -- 家庭住址（具体地址）
            ,telephone -- 手机号码
            ,marital_status -- 婚姻状况
            ,education -- 学历
            ,apply_balance -- 申请金额(元)
            ,apply_type -- 申请类型：person个人；company企业；
            ,repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,location_addr -- 定位地址
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,remarks -- 备注
            ,lsxd_busi_type -- 零售信贷业务品种
            ,cust_no -- 核心客户号
            ,is_new_citizen -- 是否新市民 字典:shfzo
            ,industry_type -- 行业类别 字典:hytx一级大类
            ,is_retired_servicemen -- 是否退役军人 字典:shfzo
            ,emp_status -- 就业状况 字典:khjyzk
            ,start_employ_ment_year -- 开始任职年份
            ,borroweramount -- 借款人出资额
            ,borrower_holdratio -- 借款人控股比例
            ,work_hold -- 家庭工作人数
            ,edu_degree -- 最高学位 字典:khzgxw
            ,bank_credit_limit_amount -- 行内限额结果
            ,cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
            ,enterprise_name -- 企业名称
            ,enterprise_region -- 企业经营地址:省市区
            ,enterprise_address -- 企业经营地址:详细地址
            ,sign_cust_id -- 安心签用户ID
            ,occupation -- 职业
            ,address_code -- 户籍行政地址,格式是：/0000/0900/0090
            ,longitude_code -- 经度
            ,latitude_code -- 纬度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cid -- 借款人ID
    ,o.loan_id -- 进件id
    ,o.code -- 借款人编码
    ,o.hand_input_name -- 用户手动输入的姓名
    ,o.cname -- 客户名称
    ,o.sex -- 性别
    ,o.age -- 年龄
    ,o.id_card_no -- 证件号码
    ,o.id_card_addr -- 身份证住址
    ,o.province_region -- 家庭住址的省市区,多级斜杠隔开
    ,o.home_addr -- 家庭住址（具体地址）
    ,o.telephone -- 手机号码
    ,o.marital_status -- 婚姻状况
    ,o.education -- 学历
    ,o.apply_balance -- 申请金额(元)
    ,o.apply_type -- 申请类型：person个人；company企业；
    ,o.repayment_period -- 还款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
    ,o.repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,o.location_addr -- 定位地址
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.isdel -- 删除标识
    ,o.remarks -- 备注
    ,o.lsxd_busi_type -- 零售信贷业务品种
    ,o.cust_no -- 核心客户号
    ,o.is_new_citizen -- 是否新市民 字典:shfzo
    ,o.industry_type -- 行业类别 字典:hytx一级大类
    ,o.is_retired_servicemen -- 是否退役军人 字典:shfzo
    ,o.emp_status -- 就业状况 字典:khjyzk
    ,o.start_employ_ment_year -- 开始任职年份
    ,o.borroweramount -- 借款人出资额
    ,o.borrower_holdratio -- 借款人控股比例
    ,o.work_hold -- 家庭工作人数
    ,o.edu_degree -- 最高学位 字典:khzgxw
    ,o.bank_credit_limit_amount -- 行内限额结果
    ,o.cust_type -- 客户类型 字典:xwdkhlx 1:经营户 2:工薪族
    ,o.enterprise_name -- 企业名称
    ,o.enterprise_region -- 企业经营地址:省市区
    ,o.enterprise_address -- 企业经营地址:详细地址
    ,o.sign_cust_id -- 安心签用户ID
    ,o.occupation -- 职业
    ,o.address_code -- 户籍行政地址,格式是：/0000/0900/0090
    ,o.longitude_code -- 经度
    ,o.latitude_code -- 纬度
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.hgls_loan_customer_bk o
    left join ${iol_schema}.hgls_loan_customer_op n
        on
            o.cid = n.cid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_customer_cl d
        on
            o.cid = d.cid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_loan_customer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_customer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_customer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_customer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_customer exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_customer_cl;
alter table ${iol_schema}.hgls_loan_customer exchange partition p_20991231 with table ${iol_schema}.hgls_loan_customer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_customer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_customer_op purge;
drop table ${iol_schema}.hgls_loan_customer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_customer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_customer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
