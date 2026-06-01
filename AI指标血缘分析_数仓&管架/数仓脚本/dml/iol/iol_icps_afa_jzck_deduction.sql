/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_deduction
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
drop table ${iol_schema}.icps_afa_jzck_deduction_ex purge;
alter table ${iol_schema}.icps_afa_jzck_deduction add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icps_afa_jzck_deduction truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_deduction_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icps_afa_jzck_deduction where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_deduction_ex(
    productcode -- 产品代号
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,reqbatno -- 请求批次号
    ,taskid -- 请求单号
    ,accno -- 扣划账户
    ,subaccno -- 扣划子账户
    ,amonut -- 扣划金额
    ,accnoname -- 账户户名
    ,idtype -- 账户证件类型
    ,id -- 账户证件号码
    ,yyaccno -- 内部户账号
    ,zxkaccnoname -- 执行款专户户名
    ,zxkbrnoname -- 执行款专户开户行
    ,zxkbrnocode -- 执行款专户开户行号
    ,zxkaccno -- 执行款专户账号
    ,zxfyname -- 执行法院名称
    ,zxfycode -- 执行法院代码
    ,cbfg -- 承办法官
    ,cbfgtel -- 承办法官联系电话
    ,cbfggzz -- 承办法官工作证编号
    ,cbfggwz -- 承办法官公务证编号
    ,tzs -- 控制通知书名称
    ,zxah -- 执行案号
    ,remark1 -- 是否续冻转解冻
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,status -- 业务处理状态
    ,zxkaccnotype -- 执行款专户账号类型
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,deducttype -- 扣划类型
    ,origtaskid -- 原任务流水号
    ,islock -- 是否锁定
    ,unfreezedate -- 解冻核心日期
    ,unfreezeserno -- 解冻核心流水
    ,unfreezestatus -- 解冻扣划解冻状态
    ,errorcode -- 错误码
    ,errormsg -- 错误描述
    ,busiserno -- 业务流水号
    ,hostdate -- 核心日期
    ,hostfreezeserial -- 核心流水
    ,globalseqno -- 全局流水号
    ,brno -- 机构号
    ,tellerno -- 柜员号
    ,authorizer -- 授权柜员号
    ,hosttype -- 账户来源
    ,subchnl -- 子户来源
    ,iscbs -- 是否为储蓄账户
    ,decramount -- 核减金额
    ,accountopenbankcode -- 执行开户行
    ,chnid -- 渠道号
    ,busisysdate -- 请求交日期
    ,origfrozedamount -- 原剩余冻结金额
    ,accruacctno -- 利息账户
    ,accruacctname -- 利息账户户名
    ,deduprcp -- 扣划本金
    ,deduint -- 扣划利息
    ,enteraccttype -- 利息转入账户分类属性
    ,accruaccttype -- 利息转入账户分类属性
    ,isspecial -- 特殊扣划标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代号
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,reqbatno -- 请求批次号
    ,taskid -- 请求单号
    ,accno -- 扣划账户
    ,subaccno -- 扣划子账户
    ,amonut -- 扣划金额
    ,accnoname -- 账户户名
    ,idtype -- 账户证件类型
    ,id -- 账户证件号码
    ,yyaccno -- 内部户账号
    ,zxkaccnoname -- 执行款专户户名
    ,zxkbrnoname -- 执行款专户开户行
    ,zxkbrnocode -- 执行款专户开户行号
    ,zxkaccno -- 执行款专户账号
    ,zxfyname -- 执行法院名称
    ,zxfycode -- 执行法院代码
    ,cbfg -- 承办法官
    ,cbfgtel -- 承办法官联系电话
    ,cbfggzz -- 承办法官工作证编号
    ,cbfggwz -- 承办法官公务证编号
    ,tzs -- 控制通知书名称
    ,zxah -- 执行案号
    ,remark1 -- 是否续冻转解冻
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,status -- 业务处理状态
    ,zxkaccnotype -- 执行款专户账号类型
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,deducttype -- 扣划类型
    ,origtaskid -- 原任务流水号
    ,islock -- 是否锁定
    ,unfreezedate -- 解冻核心日期
    ,unfreezeserno -- 解冻核心流水
    ,unfreezestatus -- 解冻扣划解冻状态
    ,errorcode -- 错误码
    ,errormsg -- 错误描述
    ,busiserno -- 业务流水号
    ,hostdate -- 核心日期
    ,hostfreezeserial -- 核心流水
    ,globalseqno -- 全局流水号
    ,brno -- 机构号
    ,tellerno -- 柜员号
    ,authorizer -- 授权柜员号
    ,hosttype -- 账户来源
    ,subchnl -- 子户来源
    ,iscbs -- 是否为储蓄账户
    ,decramount -- 核减金额
    ,accountopenbankcode -- 执行开户行
    ,chnid -- 渠道号
    ,busisysdate -- 请求交日期
    ,origfrozedamount -- 原剩余冻结金额
    ,accruacctno -- 利息账户
    ,accruacctname -- 利息账户户名
    ,deduprcp -- 扣划本金
    ,deduint -- 扣划利息
    ,enteraccttype -- 利息转入账户分类属性
    ,accruaccttype -- 利息转入账户分类属性
    ,isspecial -- 特殊扣划标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_deduction
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_deduction exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_deduction_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_deduction to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_deduction_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_deduction',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);