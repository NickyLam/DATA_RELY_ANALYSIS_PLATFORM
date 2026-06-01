/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ntsignacctinfo_new
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_new_ex purge;
alter table ${iol_schema}.mpcs_a1ntsignacctinfo_new add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a1ntsignacctinfo_new truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1ntsignacctinfo_new_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ntsignacctinfo_new where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1ntsignacctinfo_new_ex(
    mainseq -- 中台流水号
    ,projectcode -- 工程编码
    ,projectname -- 工程名称
    ,code -- 企业ID
    ,qybh -- 企业编码
    ,name -- 企业名称
    ,fbqycode -- 发包企业ID
    ,fbqyname -- 发包企业名称
    ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
    ,specialaccount -- 专用账户号
    ,accountname -- 专用账户户名
    ,bankjointnumber -- 开户银行联行号
    ,optype -- 开户类型 1-新开户 2-变更开户
    ,opbalance -- 余额
    ,ophandler -- 开户经办人姓名
    ,ophandleridcard -- 开户经办人身份证号
    ,opcreatime -- 开户时间
    ,opremarks -- 开户备注信息
    ,destype -- 销户类型
    ,balance -- 结余资金
    ,deshandler -- 销户经办人姓名
    ,deshandleridcard -- 销户经办人身份证号
    ,transactionno -- 销户转账交易号
    ,destaccount -- 提取账户号
    ,destname -- 提取账户名称
    ,destorgancode -- 提取账户机构代码
    ,destbusicode -- 提取账户营业执照号
    ,descreatime -- 销户时间
    ,desremarks -- 销户备注信息
    ,status -- 账户状态 0-销户 1-开户
    ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
    ,updt -- 更新时间
    ,tlrno -- 柜员号
    ,brcno -- 交易机构
    ,oldspecialaccount -- 原转用账户号
    ,projno -- 行内项目号
    ,spectp -- 账户类型    4 基本账户    6 一般账户
    ,glacno -- 内部账户
    ,glacna -- 内部账户名称
    ,payacctno -- 他行基本户
    ,payacctname -- 他行基本户户名
    ,payacctbank -- 他行基本户开户行
    ,accounttype -- 第三方账户类型：1-工人工资专用账户 2-保证金账户 3-工人工资保证金混合账户
    ,bondfilepath -- 保证金凭证上传路径
    ,bondamount -- 保证金金额,非负整数并以分为单位
    ,bonduploadseq -- 保证金凭证上传流水
    ,bonduploadstatus -- 保证金凭证上传状态 0-待上传 1-已上传 2-上传失败 3-上传保证金文件不存在
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainseq -- 中台流水号
    ,projectcode -- 工程编码
    ,projectname -- 工程名称
    ,code -- 企业ID
    ,qybh -- 企业编码
    ,name -- 企业名称
    ,fbqycode -- 发包企业ID
    ,fbqyname -- 发包企业名称
    ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
    ,specialaccount -- 专用账户号
    ,accountname -- 专用账户户名
    ,bankjointnumber -- 开户银行联行号
    ,optype -- 开户类型 1-新开户 2-变更开户
    ,opbalance -- 余额
    ,ophandler -- 开户经办人姓名
    ,ophandleridcard -- 开户经办人身份证号
    ,opcreatime -- 开户时间
    ,opremarks -- 开户备注信息
    ,destype -- 销户类型
    ,balance -- 结余资金
    ,deshandler -- 销户经办人姓名
    ,deshandleridcard -- 销户经办人身份证号
    ,transactionno -- 销户转账交易号
    ,destaccount -- 提取账户号
    ,destname -- 提取账户名称
    ,destorgancode -- 提取账户机构代码
    ,destbusicode -- 提取账户营业执照号
    ,descreatime -- 销户时间
    ,desremarks -- 销户备注信息
    ,status -- 账户状态 0-销户 1-开户
    ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
    ,updt -- 更新时间
    ,tlrno -- 柜员号
    ,brcno -- 交易机构
    ,oldspecialaccount -- 原转用账户号
    ,projno -- 行内项目号
    ,spectp -- 账户类型    4 基本账户    6 一般账户
    ,glacno -- 内部账户
    ,glacna -- 内部账户名称
    ,payacctno -- 他行基本户
    ,payacctname -- 他行基本户户名
    ,payacctbank -- 他行基本户开户行
    ,accounttype -- 第三方账户类型：1-工人工资专用账户 2-保证金账户 3-工人工资保证金混合账户
    ,bondfilepath -- 保证金凭证上传路径
    ,bondamount -- 保证金金额,非负整数并以分为单位
    ,bonduploadseq -- 保证金凭证上传流水
    ,bonduploadstatus -- 保证金凭证上传状态 0-待上传 1-已上传 2-上传失败 3-上传保证金文件不存在
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1ntsignacctinfo_new
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1ntsignacctinfo_new exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ntsignacctinfo_new_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ntsignacctinfo_new to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_new_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ntsignacctinfo_new',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);