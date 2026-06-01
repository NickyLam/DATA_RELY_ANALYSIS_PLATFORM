/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cbss_iab_atmu
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
alter table ${itl_schema}.itl_edw_cbss_iab_atmu drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cbss_iab_atmu drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cbss_iab_atmu add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cbss_iab_atmu partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,atmcod  -- ATM设备号
    ,brchno  -- 所属部门
    ,userid  -- 用户号
    ,csbxno  -- 钱箱号
    ,tmnlno  -- 终端编号
    ,atmtyp  -- ATM类型
    ,atmsts  -- ATM状态
    ,atmmod  -- ATM型号
    ,addres  -- 安装地址
    ,stdate  -- 启用日期
    ,eddate  -- 终止日期
    ,mgname  -- 管理员名
    ,teleno  -- 联系电话
    ,mgmode  -- 管理模式
    ,qjcoid  -- 清机公司编号
    ,qjtsti  -- 清机时间戳
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.atmcod,chr(13),''),chr(10),'')  -- ATM设备号
    ,replace(replace(t1.brchno,chr(13),''),chr(10),'')  -- 所属部门
    ,replace(replace(t1.userid,chr(13),''),chr(10),'')  -- 用户号
    ,replace(replace(t1.csbxno,chr(13),''),chr(10),'')  -- 钱箱号
    ,replace(replace(t1.tmnlno,chr(13),''),chr(10),'')  -- 终端编号
    ,replace(replace(t1.atmtyp,chr(13),''),chr(10),'')  -- ATM类型
    ,replace(replace(t1.atmsts,chr(13),''),chr(10),'')  -- ATM状态
    ,replace(replace(t1.atmmod,chr(13),''),chr(10),'')  -- ATM型号
    ,replace(replace(t1.addres,chr(13),''),chr(10),'')  -- 安装地址
    ,replace(replace(t1.stdate,chr(13),''),chr(10),'')  -- 启用日期
    ,replace(replace(t1.eddate,chr(13),''),chr(10),'')  -- 终止日期
    ,replace(replace(t1.mgname,chr(13),''),chr(10),'')  -- 管理员名
    ,replace(replace(t1.teleno,chr(13),''),chr(10),'')  -- 联系电话
    ,replace(replace(t1.mgmode,chr(13),''),chr(10),'')  -- 管理模式
    ,replace(replace(t1.qjcoid,chr(13),''),chr(10),'')  -- 清机公司编号
    ,replace(replace(t1.qjtsti,chr(13),''),chr(10),'')  -- 清机时间戳
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_cbss_iab_atmu t1    --登录记录表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cbss_iab_atmu',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);