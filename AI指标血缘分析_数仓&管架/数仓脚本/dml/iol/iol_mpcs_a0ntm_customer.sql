/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_customer
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
create table ${iol_schema}.mpcs_a0ntm_customer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_customer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_customer_op purge;
drop table ${iol_schema}.mpcs_a0ntm_customer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_customer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_customer where 0=1;

create table ${iol_schema}.mpcs_a0ntm_customer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_customer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_customer_cl(
            org -- 机构号
            ,cust_id -- 客户编号
            ,id_no -- 证件号码
            ,id_type -- 证件类型
            ,title -- 称谓
            ,name -- 姓名
            ,gender -- 性别
            ,birthday -- 生日
            ,occupation -- 职业
            ,bankmember_no -- 本行员工号
            ,nationality -- 国籍
            ,pr_of_country -- 是否永久居住
            ,residency_country_cd -- 永久居住地国家代码
            ,buser_field1 -- 系统备用域1
            ,buser_field2 -- 系统备用域2
            ,buser_field3 -- 系统备用域3
            ,buser_field4 -- 系统备用域4
            ,buser_field5 -- 系统备用域5
            ,buser_field6 -- 系统备用域6
            ,buser_field7 -- 系统备用域7
            ,buser_field8 -- 系统备用域8
            ,buser_field9 -- 系统备用域9
            ,mobile_no -- 移动电话
            ,buser_field10 -- 系统备用域10
            ,emp_status -- 就业状态
            ,nbr_of_dependents -- 抚养人数
            ,language_ind -- 语言代码
            ,setup_date -- 创建日期
            ,social_ins_amt -- 社保缴存金额
            ,drive_license_id -- 驾驶证号码
            ,drive_lic_reg_date -- 驾驶证登记日期
            ,obligate_question -- 预留问题
            ,obligate_answer -- 预留答案
            ,emp_stability -- 工作稳定性
            ,corp_name -- 公司名称
            ,user_code1 -- 用户自定义代码1
            ,user_code2 -- 用户自定义代码2
            ,user_code3 -- 用户自定义代码3
            ,user_code4 -- 用户自定义代码4
            ,user_code5 -- 用户自定义代码5
            ,user_code6 -- 用户自定义代码6
            ,user_date1 -- 用户自定义日期1
            ,user_date2 -- 用户自定义日期2
            ,user_date3 -- 用户自定义日期3
            ,user_date4 -- 用户自定义日期4
            ,user_date5 -- 用户自定义日期5
            ,user_date6 -- 用户自定义日期6
            ,user_number1 -- 用户自定义笔数1
            ,user_number2 -- 用户自定义笔数2
            ,user_number3 -- 用户自定义笔数3
            ,user_number4 -- 用户自定义笔数4
            ,user_number5 -- 用户自定义笔数5
            ,user_number6 -- 用户自定义笔数6
            ,user_field1 -- 用户自定义域1
            ,user_field2 -- 用户自定义域2
            ,user_field3 -- 用户自定义域3
            ,user_field4 -- 用户自定义域4
            ,user_field5 -- 用户自定义域5
            ,user_field6 -- 用户自定义域6
            ,user_amt1 -- 用户自定义金额1
            ,user_amt2 -- 用户自定义金额2
            ,user_amt3 -- 用户自定义金额3
            ,user_amt4 -- 用户自定义金额4
            ,user_amt5 -- 用户自定义金额5
            ,user_amt6 -- 昨日贷记卡承诺余额
            ,bank_customer_id -- 行内统一用户号
            ,emb_name -- 拼音名
            ,jpa_version -- 乐观锁版本号
            ,cust_limit_id -- 客户额度ID
            ,last_modified_datetime -- 修改时间
            ,buser_field21 -- 系统备用域21
            ,buser_field22 -- 系统备用域22
            ,surname -- 姓氏
            ,created_datetime -- 创建时间
            ,buser_field23 -- 系统备用域24
            ,buser_field24 -- 系统备用域24
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
            ,cbscustno -- 核心对应的客户ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_customer_op(
            org -- 机构号
            ,cust_id -- 客户编号
            ,id_no -- 证件号码
            ,id_type -- 证件类型
            ,title -- 称谓
            ,name -- 姓名
            ,gender -- 性别
            ,birthday -- 生日
            ,occupation -- 职业
            ,bankmember_no -- 本行员工号
            ,nationality -- 国籍
            ,pr_of_country -- 是否永久居住
            ,residency_country_cd -- 永久居住地国家代码
            ,buser_field1 -- 系统备用域1
            ,buser_field2 -- 系统备用域2
            ,buser_field3 -- 系统备用域3
            ,buser_field4 -- 系统备用域4
            ,buser_field5 -- 系统备用域5
            ,buser_field6 -- 系统备用域6
            ,buser_field7 -- 系统备用域7
            ,buser_field8 -- 系统备用域8
            ,buser_field9 -- 系统备用域9
            ,mobile_no -- 移动电话
            ,buser_field10 -- 系统备用域10
            ,emp_status -- 就业状态
            ,nbr_of_dependents -- 抚养人数
            ,language_ind -- 语言代码
            ,setup_date -- 创建日期
            ,social_ins_amt -- 社保缴存金额
            ,drive_license_id -- 驾驶证号码
            ,drive_lic_reg_date -- 驾驶证登记日期
            ,obligate_question -- 预留问题
            ,obligate_answer -- 预留答案
            ,emp_stability -- 工作稳定性
            ,corp_name -- 公司名称
            ,user_code1 -- 用户自定义代码1
            ,user_code2 -- 用户自定义代码2
            ,user_code3 -- 用户自定义代码3
            ,user_code4 -- 用户自定义代码4
            ,user_code5 -- 用户自定义代码5
            ,user_code6 -- 用户自定义代码6
            ,user_date1 -- 用户自定义日期1
            ,user_date2 -- 用户自定义日期2
            ,user_date3 -- 用户自定义日期3
            ,user_date4 -- 用户自定义日期4
            ,user_date5 -- 用户自定义日期5
            ,user_date6 -- 用户自定义日期6
            ,user_number1 -- 用户自定义笔数1
            ,user_number2 -- 用户自定义笔数2
            ,user_number3 -- 用户自定义笔数3
            ,user_number4 -- 用户自定义笔数4
            ,user_number5 -- 用户自定义笔数5
            ,user_number6 -- 用户自定义笔数6
            ,user_field1 -- 用户自定义域1
            ,user_field2 -- 用户自定义域2
            ,user_field3 -- 用户自定义域3
            ,user_field4 -- 用户自定义域4
            ,user_field5 -- 用户自定义域5
            ,user_field6 -- 用户自定义域6
            ,user_amt1 -- 用户自定义金额1
            ,user_amt2 -- 用户自定义金额2
            ,user_amt3 -- 用户自定义金额3
            ,user_amt4 -- 用户自定义金额4
            ,user_amt5 -- 用户自定义金额5
            ,user_amt6 -- 昨日贷记卡承诺余额
            ,bank_customer_id -- 行内统一用户号
            ,emb_name -- 拼音名
            ,jpa_version -- 乐观锁版本号
            ,cust_limit_id -- 客户额度ID
            ,last_modified_datetime -- 修改时间
            ,buser_field21 -- 系统备用域21
            ,buser_field22 -- 系统备用域22
            ,surname -- 姓氏
            ,created_datetime -- 创建时间
            ,buser_field23 -- 系统备用域24
            ,buser_field24 -- 系统备用域24
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
            ,cbscustno -- 核心对应的客户ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.id_no, o.id_no) as id_no -- 证件号码
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型
    ,nvl(n.title, o.title) as title -- 称谓
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.bankmember_no, o.bankmember_no) as bankmember_no -- 本行员工号
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.pr_of_country, o.pr_of_country) as pr_of_country -- 是否永久居住
    ,nvl(n.residency_country_cd, o.residency_country_cd) as residency_country_cd -- 永久居住地国家代码
    ,nvl(n.buser_field1, o.buser_field1) as buser_field1 -- 系统备用域1
    ,nvl(n.buser_field2, o.buser_field2) as buser_field2 -- 系统备用域2
    ,nvl(n.buser_field3, o.buser_field3) as buser_field3 -- 系统备用域3
    ,nvl(n.buser_field4, o.buser_field4) as buser_field4 -- 系统备用域4
    ,nvl(n.buser_field5, o.buser_field5) as buser_field5 -- 系统备用域5
    ,nvl(n.buser_field6, o.buser_field6) as buser_field6 -- 系统备用域6
    ,nvl(n.buser_field7, o.buser_field7) as buser_field7 -- 系统备用域7
    ,nvl(n.buser_field8, o.buser_field8) as buser_field8 -- 系统备用域8
    ,nvl(n.buser_field9, o.buser_field9) as buser_field9 -- 系统备用域9
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 移动电话
    ,nvl(n.buser_field10, o.buser_field10) as buser_field10 -- 系统备用域10
    ,nvl(n.emp_status, o.emp_status) as emp_status -- 就业状态
    ,nvl(n.nbr_of_dependents, o.nbr_of_dependents) as nbr_of_dependents -- 抚养人数
    ,nvl(n.language_ind, o.language_ind) as language_ind -- 语言代码
    ,nvl(n.setup_date, o.setup_date) as setup_date -- 创建日期
    ,nvl(n.social_ins_amt, o.social_ins_amt) as social_ins_amt -- 社保缴存金额
    ,nvl(n.drive_license_id, o.drive_license_id) as drive_license_id -- 驾驶证号码
    ,nvl(n.drive_lic_reg_date, o.drive_lic_reg_date) as drive_lic_reg_date -- 驾驶证登记日期
    ,nvl(n.obligate_question, o.obligate_question) as obligate_question -- 预留问题
    ,nvl(n.obligate_answer, o.obligate_answer) as obligate_answer -- 预留答案
    ,nvl(n.emp_stability, o.emp_stability) as emp_stability -- 工作稳定性
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.user_code1, o.user_code1) as user_code1 -- 用户自定义代码1
    ,nvl(n.user_code2, o.user_code2) as user_code2 -- 用户自定义代码2
    ,nvl(n.user_code3, o.user_code3) as user_code3 -- 用户自定义代码3
    ,nvl(n.user_code4, o.user_code4) as user_code4 -- 用户自定义代码4
    ,nvl(n.user_code5, o.user_code5) as user_code5 -- 用户自定义代码5
    ,nvl(n.user_code6, o.user_code6) as user_code6 -- 用户自定义代码6
    ,nvl(n.user_date1, o.user_date1) as user_date1 -- 用户自定义日期1
    ,nvl(n.user_date2, o.user_date2) as user_date2 -- 用户自定义日期2
    ,nvl(n.user_date3, o.user_date3) as user_date3 -- 用户自定义日期3
    ,nvl(n.user_date4, o.user_date4) as user_date4 -- 用户自定义日期4
    ,nvl(n.user_date5, o.user_date5) as user_date5 -- 用户自定义日期5
    ,nvl(n.user_date6, o.user_date6) as user_date6 -- 用户自定义日期6
    ,nvl(n.user_number1, o.user_number1) as user_number1 -- 用户自定义笔数1
    ,nvl(n.user_number2, o.user_number2) as user_number2 -- 用户自定义笔数2
    ,nvl(n.user_number3, o.user_number3) as user_number3 -- 用户自定义笔数3
    ,nvl(n.user_number4, o.user_number4) as user_number4 -- 用户自定义笔数4
    ,nvl(n.user_number5, o.user_number5) as user_number5 -- 用户自定义笔数5
    ,nvl(n.user_number6, o.user_number6) as user_number6 -- 用户自定义笔数6
    ,nvl(n.user_field1, o.user_field1) as user_field1 -- 用户自定义域1
    ,nvl(n.user_field2, o.user_field2) as user_field2 -- 用户自定义域2
    ,nvl(n.user_field3, o.user_field3) as user_field3 -- 用户自定义域3
    ,nvl(n.user_field4, o.user_field4) as user_field4 -- 用户自定义域4
    ,nvl(n.user_field5, o.user_field5) as user_field5 -- 用户自定义域5
    ,nvl(n.user_field6, o.user_field6) as user_field6 -- 用户自定义域6
    ,nvl(n.user_amt1, o.user_amt1) as user_amt1 -- 用户自定义金额1
    ,nvl(n.user_amt2, o.user_amt2) as user_amt2 -- 用户自定义金额2
    ,nvl(n.user_amt3, o.user_amt3) as user_amt3 -- 用户自定义金额3
    ,nvl(n.user_amt4, o.user_amt4) as user_amt4 -- 用户自定义金额4
    ,nvl(n.user_amt5, o.user_amt5) as user_amt5 -- 用户自定义金额5
    ,nvl(n.user_amt6, o.user_amt6) as user_amt6 -- 昨日贷记卡承诺余额
    ,nvl(n.bank_customer_id, o.bank_customer_id) as bank_customer_id -- 行内统一用户号
    ,nvl(n.emb_name, o.emb_name) as emb_name -- 拼音名
    ,nvl(n.jpa_version, o.jpa_version) as jpa_version -- 乐观锁版本号
    ,nvl(n.cust_limit_id, o.cust_limit_id) as cust_limit_id -- 客户额度ID
    ,nvl(n.last_modified_datetime, o.last_modified_datetime) as last_modified_datetime -- 修改时间
    ,nvl(n.buser_field21, o.buser_field21) as buser_field21 -- 系统备用域21
    ,nvl(n.buser_field22, o.buser_field22) as buser_field22 -- 系统备用域22
    ,nvl(n.surname, o.surname) as surname -- 姓氏
    ,nvl(n.created_datetime, o.created_datetime) as created_datetime -- 创建时间
    ,nvl(n.buser_field23, o.buser_field23) as buser_field23 -- 系统备用域24
    ,nvl(n.buser_field24, o.buser_field24) as buser_field24 -- 系统备用域24
    ,nvl(n.batchfilename, o.batchfilename) as batchfilename -- 批量文件名
    ,nvl(n.seqno, o.seqno) as seqno -- 序列号
    ,nvl(n.openflag, o.openflag) as openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
    ,nvl(n.cbscustno, o.cbscustno) as cbscustno -- 核心对应的客户ID
    ,case when
            n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ntm_customer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ntm_customer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_id = n.cust_id
where (
        o.cust_id is null
    )
    or (
        n.cust_id is null
    )
    or (
        o.org <> n.org
        or o.id_no <> n.id_no
        or o.id_type <> n.id_type
        or o.title <> n.title
        or o.name <> n.name
        or o.gender <> n.gender
        or o.birthday <> n.birthday
        or o.occupation <> n.occupation
        or o.bankmember_no <> n.bankmember_no
        or o.nationality <> n.nationality
        or o.pr_of_country <> n.pr_of_country
        or o.residency_country_cd <> n.residency_country_cd
        or o.buser_field1 <> n.buser_field1
        or o.buser_field2 <> n.buser_field2
        or o.buser_field3 <> n.buser_field3
        or o.buser_field4 <> n.buser_field4
        or o.buser_field5 <> n.buser_field5
        or o.buser_field6 <> n.buser_field6
        or o.buser_field7 <> n.buser_field7
        or o.buser_field8 <> n.buser_field8
        or o.buser_field9 <> n.buser_field9
        or o.mobile_no <> n.mobile_no
        or o.buser_field10 <> n.buser_field10
        or o.emp_status <> n.emp_status
        or o.nbr_of_dependents <> n.nbr_of_dependents
        or o.language_ind <> n.language_ind
        or o.setup_date <> n.setup_date
        or o.social_ins_amt <> n.social_ins_amt
        or o.drive_license_id <> n.drive_license_id
        or o.drive_lic_reg_date <> n.drive_lic_reg_date
        or o.obligate_question <> n.obligate_question
        or o.obligate_answer <> n.obligate_answer
        or o.emp_stability <> n.emp_stability
        or o.corp_name <> n.corp_name
        or o.user_code1 <> n.user_code1
        or o.user_code2 <> n.user_code2
        or o.user_code3 <> n.user_code3
        or o.user_code4 <> n.user_code4
        or o.user_code5 <> n.user_code5
        or o.user_code6 <> n.user_code6
        or o.user_date1 <> n.user_date1
        or o.user_date2 <> n.user_date2
        or o.user_date3 <> n.user_date3
        or o.user_date4 <> n.user_date4
        or o.user_date5 <> n.user_date5
        or o.user_date6 <> n.user_date6
        or o.user_number1 <> n.user_number1
        or o.user_number2 <> n.user_number2
        or o.user_number3 <> n.user_number3
        or o.user_number4 <> n.user_number4
        or o.user_number5 <> n.user_number5
        or o.user_number6 <> n.user_number6
        or o.user_field1 <> n.user_field1
        or o.user_field2 <> n.user_field2
        or o.user_field3 <> n.user_field3
        or o.user_field4 <> n.user_field4
        or o.user_field5 <> n.user_field5
        or o.user_field6 <> n.user_field6
        or o.user_amt1 <> n.user_amt1
        or o.user_amt2 <> n.user_amt2
        or o.user_amt3 <> n.user_amt3
        or o.user_amt4 <> n.user_amt4
        or o.user_amt5 <> n.user_amt5
        or o.user_amt6 <> n.user_amt6
        or o.bank_customer_id <> n.bank_customer_id
        or o.emb_name <> n.emb_name
        or o.jpa_version <> n.jpa_version
        or o.cust_limit_id <> n.cust_limit_id
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.buser_field21 <> n.buser_field21
        or o.buser_field22 <> n.buser_field22
        or o.surname <> n.surname
        or o.created_datetime <> n.created_datetime
        or o.buser_field23 <> n.buser_field23
        or o.buser_field24 <> n.buser_field24
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
        or o.openflag <> n.openflag
        or o.cbscustno <> n.cbscustno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_customer_cl(
            org -- 机构号
            ,cust_id -- 客户编号
            ,id_no -- 证件号码
            ,id_type -- 证件类型
            ,title -- 称谓
            ,name -- 姓名
            ,gender -- 性别
            ,birthday -- 生日
            ,occupation -- 职业
            ,bankmember_no -- 本行员工号
            ,nationality -- 国籍
            ,pr_of_country -- 是否永久居住
            ,residency_country_cd -- 永久居住地国家代码
            ,buser_field1 -- 系统备用域1
            ,buser_field2 -- 系统备用域2
            ,buser_field3 -- 系统备用域3
            ,buser_field4 -- 系统备用域4
            ,buser_field5 -- 系统备用域5
            ,buser_field6 -- 系统备用域6
            ,buser_field7 -- 系统备用域7
            ,buser_field8 -- 系统备用域8
            ,buser_field9 -- 系统备用域9
            ,mobile_no -- 移动电话
            ,buser_field10 -- 系统备用域10
            ,emp_status -- 就业状态
            ,nbr_of_dependents -- 抚养人数
            ,language_ind -- 语言代码
            ,setup_date -- 创建日期
            ,social_ins_amt -- 社保缴存金额
            ,drive_license_id -- 驾驶证号码
            ,drive_lic_reg_date -- 驾驶证登记日期
            ,obligate_question -- 预留问题
            ,obligate_answer -- 预留答案
            ,emp_stability -- 工作稳定性
            ,corp_name -- 公司名称
            ,user_code1 -- 用户自定义代码1
            ,user_code2 -- 用户自定义代码2
            ,user_code3 -- 用户自定义代码3
            ,user_code4 -- 用户自定义代码4
            ,user_code5 -- 用户自定义代码5
            ,user_code6 -- 用户自定义代码6
            ,user_date1 -- 用户自定义日期1
            ,user_date2 -- 用户自定义日期2
            ,user_date3 -- 用户自定义日期3
            ,user_date4 -- 用户自定义日期4
            ,user_date5 -- 用户自定义日期5
            ,user_date6 -- 用户自定义日期6
            ,user_number1 -- 用户自定义笔数1
            ,user_number2 -- 用户自定义笔数2
            ,user_number3 -- 用户自定义笔数3
            ,user_number4 -- 用户自定义笔数4
            ,user_number5 -- 用户自定义笔数5
            ,user_number6 -- 用户自定义笔数6
            ,user_field1 -- 用户自定义域1
            ,user_field2 -- 用户自定义域2
            ,user_field3 -- 用户自定义域3
            ,user_field4 -- 用户自定义域4
            ,user_field5 -- 用户自定义域5
            ,user_field6 -- 用户自定义域6
            ,user_amt1 -- 用户自定义金额1
            ,user_amt2 -- 用户自定义金额2
            ,user_amt3 -- 用户自定义金额3
            ,user_amt4 -- 用户自定义金额4
            ,user_amt5 -- 用户自定义金额5
            ,user_amt6 -- 昨日贷记卡承诺余额
            ,bank_customer_id -- 行内统一用户号
            ,emb_name -- 拼音名
            ,jpa_version -- 乐观锁版本号
            ,cust_limit_id -- 客户额度ID
            ,last_modified_datetime -- 修改时间
            ,buser_field21 -- 系统备用域21
            ,buser_field22 -- 系统备用域22
            ,surname -- 姓氏
            ,created_datetime -- 创建时间
            ,buser_field23 -- 系统备用域24
            ,buser_field24 -- 系统备用域24
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
            ,cbscustno -- 核心对应的客户ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_customer_op(
            org -- 机构号
            ,cust_id -- 客户编号
            ,id_no -- 证件号码
            ,id_type -- 证件类型
            ,title -- 称谓
            ,name -- 姓名
            ,gender -- 性别
            ,birthday -- 生日
            ,occupation -- 职业
            ,bankmember_no -- 本行员工号
            ,nationality -- 国籍
            ,pr_of_country -- 是否永久居住
            ,residency_country_cd -- 永久居住地国家代码
            ,buser_field1 -- 系统备用域1
            ,buser_field2 -- 系统备用域2
            ,buser_field3 -- 系统备用域3
            ,buser_field4 -- 系统备用域4
            ,buser_field5 -- 系统备用域5
            ,buser_field6 -- 系统备用域6
            ,buser_field7 -- 系统备用域7
            ,buser_field8 -- 系统备用域8
            ,buser_field9 -- 系统备用域9
            ,mobile_no -- 移动电话
            ,buser_field10 -- 系统备用域10
            ,emp_status -- 就业状态
            ,nbr_of_dependents -- 抚养人数
            ,language_ind -- 语言代码
            ,setup_date -- 创建日期
            ,social_ins_amt -- 社保缴存金额
            ,drive_license_id -- 驾驶证号码
            ,drive_lic_reg_date -- 驾驶证登记日期
            ,obligate_question -- 预留问题
            ,obligate_answer -- 预留答案
            ,emp_stability -- 工作稳定性
            ,corp_name -- 公司名称
            ,user_code1 -- 用户自定义代码1
            ,user_code2 -- 用户自定义代码2
            ,user_code3 -- 用户自定义代码3
            ,user_code4 -- 用户自定义代码4
            ,user_code5 -- 用户自定义代码5
            ,user_code6 -- 用户自定义代码6
            ,user_date1 -- 用户自定义日期1
            ,user_date2 -- 用户自定义日期2
            ,user_date3 -- 用户自定义日期3
            ,user_date4 -- 用户自定义日期4
            ,user_date5 -- 用户自定义日期5
            ,user_date6 -- 用户自定义日期6
            ,user_number1 -- 用户自定义笔数1
            ,user_number2 -- 用户自定义笔数2
            ,user_number3 -- 用户自定义笔数3
            ,user_number4 -- 用户自定义笔数4
            ,user_number5 -- 用户自定义笔数5
            ,user_number6 -- 用户自定义笔数6
            ,user_field1 -- 用户自定义域1
            ,user_field2 -- 用户自定义域2
            ,user_field3 -- 用户自定义域3
            ,user_field4 -- 用户自定义域4
            ,user_field5 -- 用户自定义域5
            ,user_field6 -- 用户自定义域6
            ,user_amt1 -- 用户自定义金额1
            ,user_amt2 -- 用户自定义金额2
            ,user_amt3 -- 用户自定义金额3
            ,user_amt4 -- 用户自定义金额4
            ,user_amt5 -- 用户自定义金额5
            ,user_amt6 -- 昨日贷记卡承诺余额
            ,bank_customer_id -- 行内统一用户号
            ,emb_name -- 拼音名
            ,jpa_version -- 乐观锁版本号
            ,cust_limit_id -- 客户额度ID
            ,last_modified_datetime -- 修改时间
            ,buser_field21 -- 系统备用域21
            ,buser_field22 -- 系统备用域22
            ,surname -- 姓氏
            ,created_datetime -- 创建时间
            ,buser_field23 -- 系统备用域24
            ,buser_field24 -- 系统备用域24
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
            ,cbscustno -- 核心对应的客户ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.cust_id -- 客户编号
    ,o.id_no -- 证件号码
    ,o.id_type -- 证件类型
    ,o.title -- 称谓
    ,o.name -- 姓名
    ,o.gender -- 性别
    ,o.birthday -- 生日
    ,o.occupation -- 职业
    ,o.bankmember_no -- 本行员工号
    ,o.nationality -- 国籍
    ,o.pr_of_country -- 是否永久居住
    ,o.residency_country_cd -- 永久居住地国家代码
    ,o.buser_field1 -- 系统备用域1
    ,o.buser_field2 -- 系统备用域2
    ,o.buser_field3 -- 系统备用域3
    ,o.buser_field4 -- 系统备用域4
    ,o.buser_field5 -- 系统备用域5
    ,o.buser_field6 -- 系统备用域6
    ,o.buser_field7 -- 系统备用域7
    ,o.buser_field8 -- 系统备用域8
    ,o.buser_field9 -- 系统备用域9
    ,o.mobile_no -- 移动电话
    ,o.buser_field10 -- 系统备用域10
    ,o.emp_status -- 就业状态
    ,o.nbr_of_dependents -- 抚养人数
    ,o.language_ind -- 语言代码
    ,o.setup_date -- 创建日期
    ,o.social_ins_amt -- 社保缴存金额
    ,o.drive_license_id -- 驾驶证号码
    ,o.drive_lic_reg_date -- 驾驶证登记日期
    ,o.obligate_question -- 预留问题
    ,o.obligate_answer -- 预留答案
    ,o.emp_stability -- 工作稳定性
    ,o.corp_name -- 公司名称
    ,o.user_code1 -- 用户自定义代码1
    ,o.user_code2 -- 用户自定义代码2
    ,o.user_code3 -- 用户自定义代码3
    ,o.user_code4 -- 用户自定义代码4
    ,o.user_code5 -- 用户自定义代码5
    ,o.user_code6 -- 用户自定义代码6
    ,o.user_date1 -- 用户自定义日期1
    ,o.user_date2 -- 用户自定义日期2
    ,o.user_date3 -- 用户自定义日期3
    ,o.user_date4 -- 用户自定义日期4
    ,o.user_date5 -- 用户自定义日期5
    ,o.user_date6 -- 用户自定义日期6
    ,o.user_number1 -- 用户自定义笔数1
    ,o.user_number2 -- 用户自定义笔数2
    ,o.user_number3 -- 用户自定义笔数3
    ,o.user_number4 -- 用户自定义笔数4
    ,o.user_number5 -- 用户自定义笔数5
    ,o.user_number6 -- 用户自定义笔数6
    ,o.user_field1 -- 用户自定义域1
    ,o.user_field2 -- 用户自定义域2
    ,o.user_field3 -- 用户自定义域3
    ,o.user_field4 -- 用户自定义域4
    ,o.user_field5 -- 用户自定义域5
    ,o.user_field6 -- 用户自定义域6
    ,o.user_amt1 -- 用户自定义金额1
    ,o.user_amt2 -- 用户自定义金额2
    ,o.user_amt3 -- 用户自定义金额3
    ,o.user_amt4 -- 用户自定义金额4
    ,o.user_amt5 -- 用户自定义金额5
    ,o.user_amt6 -- 昨日贷记卡承诺余额
    ,o.bank_customer_id -- 行内统一用户号
    ,o.emb_name -- 拼音名
    ,o.jpa_version -- 乐观锁版本号
    ,o.cust_limit_id -- 客户额度ID
    ,o.last_modified_datetime -- 修改时间
    ,o.buser_field21 -- 系统备用域21
    ,o.buser_field22 -- 系统备用域22
    ,o.surname -- 姓氏
    ,o.created_datetime -- 创建时间
    ,o.buser_field23 -- 系统备用域24
    ,o.buser_field24 -- 系统备用域24
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.openflag -- 核心开户状态：0:未开户 1:已开户 2:开户失败
    ,o.cbscustno -- 核心对应的客户ID
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
from ${iol_schema}.mpcs_a0ntm_customer_bk o
    left join ${iol_schema}.mpcs_a0ntm_customer_op n
        on
            o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ntm_customer_cl d
        on
            o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_customer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_customer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_customer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_customer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_customer exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_customer_cl;
alter table ${iol_schema}.mpcs_a0ntm_customer exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_customer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_customer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_customer_op purge;
drop table ${iol_schema}.mpcs_a0ntm_customer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_customer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_customer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
