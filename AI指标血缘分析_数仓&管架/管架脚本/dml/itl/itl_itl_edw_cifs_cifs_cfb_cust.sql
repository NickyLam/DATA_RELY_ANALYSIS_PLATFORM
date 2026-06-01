/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cifs_cifs_cfb_cust
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
alter table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cifs_cifs_cfb_cust partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,custno  -- CIF客户号
    ,custcn  -- 客户中文名称
    ,custen  -- 英文名称
    ,custlc  -- 最近曾用中文名
    ,custle  -- 最近曾用英文名
    ,custtp  -- 客户类型
    ,custlv  -- 客户级别
    ,statlv  -- 当前评级状态
    ,jonttg  -- 联名客户标志
    ,isblak  -- 是否黑名单客户
    ,doubtp  -- 疑似客户类型
    ,tttrib  -- 综合贡献度
    ,ttrema  -- 客户总积分
    ,risklv  -- 风险等级
    ,custst  -- 客户状态
    ,opendt  -- 开户日期
    ,openbr  -- 开户机构
    ,openus  -- 开户柜员
    ,closdt  -- 销户日期
    ,closbr  -- 销户机构
    ,closus  -- 销户柜员
    ,datatp  -- 数据类型:   1增量客户 0存量客户
    ,crecdt  -- 创建日期
    ,roletp  -- 参与者类别
    ,isincu  -- 是否系统内客户
    ,iscred  -- 是否授信客户
    ,credid  -- 信用评级ID
    ,credln  -- 授信额度
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.custno,chr(13),''),chr(10),'')  -- CIF客户号
    ,replace(replace(t1.custcn,chr(13),''),chr(10),'')  -- 客户中文名称
    ,replace(replace(t1.custen,chr(13),''),chr(10),'')  -- 英文名称
    ,replace(replace(t1.custlc,chr(13),''),chr(10),'')  -- 最近曾用中文名
    ,replace(replace(t1.custle,chr(13),''),chr(10),'')  -- 最近曾用英文名
    ,replace(replace(t1.custtp,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(t1.custlv,chr(13),''),chr(10),'')  -- 客户级别
    ,replace(replace(t1.statlv,chr(13),''),chr(10),'')  -- 当前评级状态
    ,replace(replace(t1.jonttg,chr(13),''),chr(10),'')  -- 联名客户标志
    ,replace(replace(t1.isblak,chr(13),''),chr(10),'')  -- 是否黑名单客户
    ,replace(replace(t1.doubtp,chr(13),''),chr(10),'')  -- 疑似客户类型
    ,t1.tttrib  -- 综合贡献度
    ,t1.ttrema  -- 客户总积分
    ,replace(replace(t1.risklv,chr(13),''),chr(10),'')  -- 风险等级
    ,replace(replace(t1.custst,chr(13),''),chr(10),'')  -- 客户状态
    ,replace(replace(t1.opendt,chr(13),''),chr(10),'')  -- 开户日期
    ,replace(replace(t1.openbr,chr(13),''),chr(10),'')  -- 开户机构
    ,replace(replace(t1.openus,chr(13),''),chr(10),'')  -- 开户柜员
    ,replace(replace(t1.closdt,chr(13),''),chr(10),'')  -- 销户日期
    ,replace(replace(t1.closbr,chr(13),''),chr(10),'')  -- 销户机构
    ,replace(replace(t1.closus,chr(13),''),chr(10),'')  -- 销户柜员
    ,replace(replace(t1.datatp,chr(13),''),chr(10),'')  -- 数据类型:   1增量客户 0存量客户
    ,t1.crecdt  -- 创建日期
    ,replace(replace(t1.roletp,chr(13),''),chr(10),'')  -- 参与者类别
    ,replace(replace(t1.isincu,chr(13),''),chr(10),'')  -- 是否系统内客户
    ,replace(replace(t1.iscred,chr(13),''),chr(10),'')  -- 是否授信客户
    ,replace(replace(t1.credid,chr(13),''),chr(10),'')  -- 信用评级ID
    ,t1.credln  -- 授信额度
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_cifs_cifs_cfb_cust t1    --客户基本信息
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cifs_cifs_cfb_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);