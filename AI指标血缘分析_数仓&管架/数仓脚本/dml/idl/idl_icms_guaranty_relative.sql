/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_guaranty_relative
CreateDate: 20250527
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_guaranty_relative drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_guaranty_relative add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_guaranty_relative (
etl_dt  --数据日期
,objecttype  --对象类型
,objectno  --对象编号
,guarantycontractno  --担保合同编号
,clrid  --担保物编号
,guarantycurrency  --担保金额币种
,inputuserid  --登记人
,inputorgid  --登记机构
,updatedate  --更新日期
,guarantysum  --担保金额
,guarantyrate  --抵/质押率（%）
,inputdate  --登记日期
,isapplyinput  --是否申请阶段录入
,migtflag  --迁移标志：crs rcr ilc upl
,updateorgid  --更新机构
,updateuserid  --更新人
,issecondmortgage  --是否二押
,relationstatus  --关联状态
,remark  --备注
,actualguarantyrate  --实际抵、质押率%
,balancefirst  --一押银行贷款余额
,businesssumfirst  --一押银行贷款金额

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype --对象类型
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno --对象编号
,replace(replace(t1.guarantycontractno,chr(13),''),chr(10),'') as guarantycontractno --担保合同编号
,replace(replace(t1.clrid,chr(13),''),chr(10),'') as clrid --担保物编号
,replace(replace(t1.guarantycurrency,chr(13),''),chr(10),'') as guarantycurrency --担保金额币种
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.updatedate as updatedate --更新日期
,t1.guarantysum as guarantysum --担保金额
,t1.guarantyrate as guarantyrate --抵/质押率（%）
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.isapplyinput,chr(13),''),chr(10),'') as isapplyinput --是否申请阶段录入
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.issecondmortgage,chr(13),''),chr(10),'') as issecondmortgage --是否二押
,replace(replace(t1.relationstatus,chr(13),''),chr(10),'') as relationstatus --关联状态
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,t1.actualguarantyrate as actualguarantyrate --实际抵、质押率%
,t1.balancefirst as balancefirst --一押银行贷款余额
,t1.businesssumfirst as businesssumfirst --一押银行贷款金额
from ${iol_schema}.icms_guaranty_relative t1    --数据来源渠道
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_guaranty_relative',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
