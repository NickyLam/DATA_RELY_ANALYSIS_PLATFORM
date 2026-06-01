/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_gzfh_pams_dxgx_kyjgx
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
alter table ${idl_schema}.gzfh_pams_dxgx_kyjgx drop partition p_${batch_date};

-- 2.1.1 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${idl_schema}.gzfh_pams_dxgx_kyjgx;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.gzfh_pams_dxgx_kyjgx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.gzfh_pams_dxgx_kyjgx (
tjrq  --数据日期
,jxdxdh  --绩效对象代号
,khdxdh  --考核对象代号
,fpjs  --分配角色
,gxly  --关系来源
,yylsh  --预约流水号
,zlbl  --认领比例
,jgmc  --机构名称
,jgdh  --机构代号
,kh  --卡号
,khh  --客户号
,khmc  --客户名称
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
,replace(replace(t1.gxly,chr(13),''),chr(10),'') as gxly --关系来源
,t1.yylsh as yylsh --预约流水号
,t1.zlbl as zlbl --认领比例
,replace(replace(jg.jgmc,chr(13),''),chr(10),'') as jgmc --机构名称
,replace(replace(jg.jgdh,chr(13),''),chr(10),'') as jgdh --机构代号
,replace(replace(k.kh,chr(13),''),chr(10),'') as kh --卡号
,replace(replace(k.khh,chr(13),''),chr(10),'') as khh --客户号
,replace(replace(k.khmc,chr(13),''),chr(10),'') as khmc --客户名称
,replace(replace(hy.hymc,chr(13),''),chr(10),'') as hymc --行员名称
,replace(replace(hy.hydh,chr(13),''),chr(10),'') as hydh --行员代号
,to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_dxgx_kyjgx t1    --对象关系-存款账户关系
inner join iol.pams_khdx_jgcy cy
on t1.khdxdh = cy.khdxdh
	and (cy.start_dt <= to_date('${batch_date}', 'yyyymmdd') and cy.end_dt > to_date('${batch_date}', 'yyyymmdd'))
	and cy.id_mark <> 'D'		
	and '${batch_date}' between cy.qsrq and cy.jsrq
inner join iol.pams_khdx_jg jg
on jg.khdxdh = cy.jgkhdxdh
	and (jg.start_dt <= to_date('${batch_date}', 'yyyymmdd') and jg.end_dt > to_date('${batch_date}', 'yyyymmdd')) 
	and jg.id_mark <> 'D'
	and jg.jgdh like '801%'
inner join iol.pams_jxdx_kzl k 
on k.jxdxdh=t1.jxdxdh
	and (k.start_dt <= to_date('${batch_date}', 'yyyymmdd') and k.end_dt > to_date('${batch_date}', 'yyyymmdd')) 
	and k.id_mark <> 'D'
inner join iol.pams_khdx_hy hy 
on t1.khdxdh=hy.khdxdh
	and (hy.start_dt <= to_date('${batch_date}', 'yyyymmdd') and hy.end_dt > to_date('${batch_date}', 'yyyymmdd'))
	and hy.id_mark <> 'D'
where t1.tjrq = '${batch_date}' and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'gzfh_pams_dxgx_kyjgx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
