/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_mmps_mmp_certificateloss
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_mmps_mmp_certificateloss drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_mmps_mmp_certificateloss drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_mmps_mmp_certificateloss add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_mmps_mmp_certificateloss partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,scanseqno  -- 扫描流水号
    ,acctno  -- 账号
    ,idtftp  -- 证件类型
    ,idtfno  -- 证件号码
    ,custna  -- 证件姓名
    ,idtaddress  -- 证件地址
    ,idtdt  -- 证件有效期
    ,stpytg  -- 挂失类型
    ,rplsfs  -- 挂失形式
    ,vouchertype  -- 凭证类型
    ,voucherno  -- 凭证号码
    ,payway  -- 支取方式
    ,rpcdtg  -- 是否申请永久卡
    ,undays  -- 挂失天数
    ,isproxy  -- 是否代理挂失
    ,proxytype  -- 代理人证件类型
    ,proxycode  -- 代理人证件号码
    ,proxyname  -- 代理人证件名称
    ,nodeid  -- 节点号
    ,pswd  -- 交易密码
    ,mobile  -- 手机号码
    ,bizcode  -- 业务编码
    ,idcheckresult  -- 联网核查结果
    ,transresult  -- 交易结果
    ,uptime  -- 更新时间
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.scanseqno,chr(13),''),chr(10),'')  -- 扫描流水号
    ,replace(replace(t1.acctno,chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(t1.idtftp,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.idtfno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.custna,chr(13),''),chr(10),'')  -- 证件姓名
    ,replace(replace(t1.idtaddress,chr(13),''),chr(10),'')  -- 证件地址
    ,replace(replace(t1.idtdt,chr(13),''),chr(10),'')  -- 证件有效期
    ,replace(replace(t1.stpytg,chr(13),''),chr(10),'')  -- 挂失类型
    ,replace(replace(t1.rplsfs,chr(13),''),chr(10),'')  -- 挂失形式
    ,replace(replace(t1.vouchertype,chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(t1.voucherno,chr(13),''),chr(10),'')  -- 凭证号码
    ,replace(replace(t1.payway,chr(13),''),chr(10),'')  -- 支取方式
    ,replace(replace(t1.rpcdtg,chr(13),''),chr(10),'')  -- 是否申请永久卡
    ,replace(replace(t1.undays,chr(13),''),chr(10),'')  -- 挂失天数
    ,replace(replace(t1.isproxy,chr(13),''),chr(10),'')  -- 是否代理挂失
    ,replace(replace(t1.proxytype,chr(13),''),chr(10),'')  -- 代理人证件类型
    ,replace(replace(t1.proxycode,chr(13),''),chr(10),'')  -- 代理人证件号码
    ,replace(replace(t1.proxyname,chr(13),''),chr(10),'')  -- 代理人证件名称
    ,replace(replace(t1.nodeid,chr(13),''),chr(10),'')  -- 节点号
    ,replace(replace(t1.pswd,chr(13),''),chr(10),'')  -- 交易密码
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 手机号码
    ,replace(replace(t1.bizcode,chr(13),''),chr(10),'')  -- 业务编码
    ,replace(replace(t1.idcheckresult,chr(13),''),chr(10),'')  -- 联网核查结果
    ,replace(replace(t1.transresult,chr(13),''),chr(10),'')  -- 交易结果
    ,t1.uptime  -- 更新时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_mmps_mmp_certificateloss t1    --凭证挂失交易信息表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_mmps_mmp_certificateloss',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);