/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_mmps_mmp_volume_active
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
alter table ${itl_schema}.itl_edw_mmps_mmp_volume_active drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_mmps_mmp_volume_active drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_mmps_mmp_volume_active add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_mmps_mmp_volume_active partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,scanseqno  -- 扫描流水号
    ,acctno  -- 账号
    ,idtftp  -- 证件类型
    ,idtfno  -- 证件号码
    ,custna  -- 证件姓名
    ,idtaddress  -- 证件地址
    ,idtdt  -- 证件有效期
    ,nodeid  -- 节点号
    ,pswd  -- 交易密码
    ,mobile  -- 手机号
    ,bizcode  -- 业务编码
    ,idcheckresult  -- 联网核查结果
    ,transresult  -- 交易结果
    ,uptime  -- 交易时间
    ,issetnewpwd  -- 是否修改密码
    ,newpwd  -- 新密码
    ,isfcfnoper  -- 是否操作非柜面非同名限额签约
    ,isfcfntype  -- 是否 非柜面非同名账户限额签约
    ,daylimit  -- 日累计限额
    ,txntimeslimit  -- 日笔数限额
    ,yearlimit  -- 年累计限额
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
    ,replace(replace(t1.nodeid,chr(13),''),chr(10),'')  -- 节点号
    ,replace(replace(t1.pswd,chr(13),''),chr(10),'')  -- 交易密码
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 手机号
    ,replace(replace(t1.bizcode,chr(13),''),chr(10),'')  -- 业务编码
    ,replace(replace(t1.idcheckresult,chr(13),''),chr(10),'')  -- 联网核查结果
    ,replace(replace(t1.transresult,chr(13),''),chr(10),'')  -- 交易结果
    ,t1.uptime  -- 交易时间
    ,replace(replace(t1.issetnewpwd,chr(13),''),chr(10),'')  -- 是否修改密码
    ,replace(replace(t1.newpwd,chr(13),''),chr(10),'')  -- 新密码
    ,replace(replace(t1.isfcfnoper,chr(13),''),chr(10),'')  -- 是否操作非柜面非同名限额签约
    ,replace(replace(t1.isfcfntype,chr(13),''),chr(10),'')  -- 是否 非柜面非同名账户限额签约
    ,replace(replace(t1.daylimit,chr(13),''),chr(10),'')  -- 日累计限额
    ,replace(replace(t1.txntimeslimit,chr(13),''),chr(10),'')  -- 日笔数限额
    ,replace(replace(t1.yearlimit,chr(13),''),chr(10),'')  -- 年累计限额
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_mmps_mmp_volume_active t1    --pad激活批量开的卡信息表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_mmps_mmp_volume_active',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);