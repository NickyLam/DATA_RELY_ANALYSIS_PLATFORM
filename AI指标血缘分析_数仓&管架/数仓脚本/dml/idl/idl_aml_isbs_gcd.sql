/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_gcd
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
alter table ${idl_schema}.aml_isbs_gcd drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_gcd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_gcd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_gcd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- 保函内部ID号
    ,ownref  -- 参考号
    ,pntinr  -- 父保函INR
    ,pnttyp  -- 保函交易类型
    ,nam  -- 交易名称
    ,credat  -- 创建日期
    ,clsdat  -- 结束日期
    ,opndat  -- 有效开始日期
    ,newexpdat  -- 申请日期
    ,ownusr  -- 负责人
    ,ver  -- 版本号
    ,clmtyp  -- 索赔种类
    ,clmctl  -- 索赔类型
    ,clmdat  -- 索赔日期
    ,cannowflg  -- 取消保函下付款
    ,msgdat  -- 拒接报文日期
    ,payrol  -- 付款人
    ,docprbrol  -- 承兑人
    ,etyextkey  -- 实体合同
    ,frepayflg  -- 免费方单标志
    ,bchkeyinr  -- 业务经办行
    ,branchinr  -- 业务所属行
    ,nraflg  -- NRA标志
    ,qsqdbh  -- 清算渠道
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- 保函内部ID号
    ,replace(replace(t1.ownref,chr(13),''),chr(10),'')  -- 参考号
    ,replace(replace(t1.pntinr,chr(13),''),chr(10),'')  -- 父保函INR
    ,replace(replace(t1.pnttyp,chr(13),''),chr(10),'')  -- 保函交易类型
    ,replace(replace(t1.nam,chr(13),''),chr(10),'')  -- 交易名称
    ,t1.credat  -- 创建日期
    ,t1.clsdat  -- 结束日期
    ,t1.opndat  -- 有效开始日期
    ,t1.newexpdat  -- 申请日期
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- 负责人
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- 版本号
    ,replace(replace(t1.clmtyp,chr(13),''),chr(10),'')  -- 索赔种类
    ,replace(replace(t1.clmctl,chr(13),''),chr(10),'')  -- 索赔类型
    ,t1.clmdat  -- 索赔日期
    ,replace(replace(t1.cannowflg,chr(13),''),chr(10),'')  -- 取消保函下付款
    ,t1.msgdat  -- 拒接报文日期
    ,replace(replace(t1.payrol,chr(13),''),chr(10),'')  -- 付款人
    ,replace(replace(t1.docprbrol,chr(13),''),chr(10),'')  -- 承兑人
    ,replace(replace(t1.etyextkey,chr(13),''),chr(10),'')  -- 实体合同
    ,replace(replace(t1.frepayflg,chr(13),''),chr(10),'')  -- 免费方单标志
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 业务经办行
    ,replace(replace(t1.branchinr,chr(13),''),chr(10),'')  -- 业务所属行
    ,replace(replace(t1.nraflg,chr(13),''),chr(10),'')  -- NRA标志
    ,replace(replace(t1.qsqdbh,chr(13),''),chr(10),'')  -- 清算渠道
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_gcd t1    --保函下索赔业务信息(存放短字节)
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_gcd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);