/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_gzfh_pams_dxgx_hyyjgx_ck
CreateDate: 20260130
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_ck drop partition p_${batch_date};

-- 2.1.1 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_ck;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_ck add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.gzfh_pams_dxgx_hyyjgx_ck (
tjrq  --数据日期
,jxdxdh  --绩效对象代号
,khdxdh  --考核对象代号
,fpjs  --分配角色
,zlbl  --认领比例
,gxhslx  --关系函数类型
,gxzt  --关系状态
,yylsh  --预约流水号
,yz  --阈值
,clbl  --存量比例
,gxly  --关系来源
,jgmc  --机构名称
,jgdh  --机构代号
,zhdh  --账户代号
,zzh  --子账户
,zhhm  --账户户名
,hymc  --行员名称
,hydh  --行员代号
,etl_dt  --ETL处理日期
,etl_timestamp  --ETL处理时间戳

)
select
t1.tjrq as tjrq --数据日期
,t1.jxdxdh as jxdxdh --绩效对象代号
,t1.khdxdh as khdxdh --考核对象代号
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs --分配角色
,t1.zlbl as zlbl --认领比例
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx --关系函数类型
,replace(replace(t1.gxzt,chr(13),''),chr(10),'') as gxzt --关系状态
,t1.yylsh as yylsh --预约流水号
,t1.yz as yz --阈值
,t1.clbl as clbl --存量比例
,replace(replace(t1.gxly,chr(13),''),chr(10),'') as gxly --关系来源
,replace(replace(jg.jgmc,chr(13),''),chr(10),'') as jgmc --机构名称
,replace(replace(jg.jgdh,chr(13),''),chr(10),'') as jgdh --机构代号
,replace(replace(zh.zhdh,chr(13),''),chr(10),'') as zhdh --账户代号
,replace(replace(zh.zzh,chr(13),''),chr(10),'') as zzh --子账户
,replace(replace(zh.zhhm,chr(13),''),chr(10),'') as zhhm --账户户名
,replace(replace(hy.hymc,chr(13),''),chr(10),'') as hymc --行员名称
,replace(replace(hy.hydh,chr(13),''),chr(10),'') as hydh --行员代号
,to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_dxgx_hyyjgx_ck t1    --对象关系-行员业绩关系-存款子账户
inner join iol.pams_khdx_jgcy cy
on t1.khdxdh = cy.khdxdh
	and (cy.start_dt <= to_date('${batch_date}', 'yyyymmdd') and cy.end_dt > to_date('${batch_date}', 'yyyymmdd'))
	and cy.id_mark <> 'D'    
and '${batch_date}' between cy.qsrq and cy.jsrq
inner join iol.pams_khdx_jg jg
on jg.khdxdh = cy.jgkhdxdh
	and (jg.start_dt <= to_date('${batch_date}', 'yyyymmdd') and jg.end_dt > to_date('${batch_date}', 'yyyymmdd')) 
	and jg.jgdh like '801%'
	and jg.id_mark <> 'D'
inner join iol.pams_jxdx_ckzh zh 
on zh.jxdxdh=t1.jxdxdh
	and (zh.start_dt <= to_date('${batch_date}', 'yyyymmdd') and zh.end_dt > to_date('${batch_date}', 'yyyymmdd'))
	and zh.id_mark <> 'D'
inner join iol.pams_khdx_hy hy 
on t1.khdxdh=hy.khdxdh
	and (hy.start_dt <= to_date('${batch_date}', 'yyyymmdd') and hy.end_dt > to_date('${batch_date}', 'yyyymmdd'))
	and hy.id_mark <> 'D'
where t1.tjrq = '${batch_date}' and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'gzfh_pams_dxgx_hyyjgx_ck',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
