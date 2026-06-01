/*
Purpose:    共性加工层-押品质押补充信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_col_inpwn_attach_info
CreateDate: 20210316
Logs:				20210512 陈伟峰 调整tmp_cmm_col_inpwn_attach_info_01逻辑
                    20220413 朱觉军	新增字段：专项信息类型代码；
                                    新增数据来源:本行理财产品和他行理财产品								

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_col_inpwn_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_col_inpwn_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_col_inpwn_attach_info_ex purge;
drop table ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01(
sccode varchar2(60),
warrantsno varchar2(250),
guarinfoname varchar2(200),
amt number(30,2)
)nologging
compress ${option_switch} for query high;

insert /*+ append */ into ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01(
sccode,
warrantsno,
guarinfoname,
amt)
select b.asset_id as sccode,
       f.wat_num as warrantsno,
       b.col_name as guarinfoname,
       (case
         when (d.estim_way_cd = '01' and
              (d.ext_estim_val >= d.ext_pre_estim_val)) then
          d.ext_pre_estim_val --01-外部评估且（外部正式评估报告的评估价值》=外部预评估报告的评估价值）取外部预评估报告的评估价值
         when (d.estim_way_cd = '01' and
              (d.ext_pre_estim_val > d.ext_estim_val)) then
          d.ext_estim_val --01-外部评估且（外部正式评估报告的评估价值<外部预评估报告的评估价值）取外部正式评估报告的评估价值
         when d.estim_way_cd = '02' then
          d.intnal_estim_val --02-内部评估 取内部评估价值
       --03-外部和内部评估且（外部正式评估报告的评估价值》=外部预评估报告的评估价值）且（外部预评估报告的评估价值》=内部评估价值）取内部评估价值
         when (d.estim_way_cd = '03' and
              d.ext_estim_val >= d.ext_pre_estim_val and
              d.ext_pre_estim_val >= d.intnal_estim_val) then
          d.intnal_estim_val
         when (d.estim_way_cd = '03' and
              d.ext_estim_val >= d.ext_pre_estim_val and
              d.intnal_estim_val >= d.ext_pre_estim_val) then
          d.ext_pre_estim_val
         when (d.estim_way_cd = '03' and
              d.intnal_estim_val >= d.ext_pre_estim_val and
              d.ext_pre_estim_val >= d.ext_estim_val) then
          d.ext_estim_val
         when (d.estim_way_cd = '03' and
              d.intnal_estim_val >= d.ext_pre_estim_val and
              d.ext_estim_val >= d.ext_pre_estim_val) then
          d.ext_pre_estim_val
         when (d.estim_way_cd = '03' and
              d.ext_pre_estim_val >= d.ext_estim_val and
              d.ext_estim_val >= d.intnal_estim_val) then
          d.intnal_estim_val
         when (d.estim_way_cd = '03' and
              d.ext_pre_estim_val >= d.ext_estim_val and
              d.intnal_estim_val >= d.ext_estim_val) then
          d.ext_estim_val
         else
          null
       end) as amt
  from ${iml_schema}.ast_col_basic_info b
 /* left join ${iml_schema}.ast_col_wat_info c
    on b.asset_id = c.asset_id
   and c.create_dt <= to_date('${batch_date}','yyyymmdd')
   and c.job_cd = 'mimsf1'
   and c.id_mark <> 'D'*/
  left join ${iml_schema}.ast_col_val_info_h d
    on b.asset_id = d.asset_id
   and d.start_dt <= to_date('${batch_date}','yyyymmdd')
   and d.end_dt > to_date('${batch_date}','yyyymmdd')
   and d.job_cd = 'mimsf1'
  left join (select e.wat_id,
                    e.asset_id,
                    e.wat_num,
                    row_number() over(partition by e.asset_id order by e.wat_id desc) as rn
                    from ${iml_schema}.ast_col_wat_info e
                   where e.create_dt <= to_date('${batch_date}','yyyymmdd')
                     and e.job_cd = 'mimsf1'
                     and e.id_mark <> 'D') f
    on b.asset_id = f.asset_id
   and f.rn = 1
 where b.create_dt <= to_date('${batch_date}','yyyymmdd')
   and b.job_cd = 'mimsf1'
   and b.id_mark <> 'D'
--   and f.wat_id = c.wat_id
   ;
   
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_inpwn_attach_info_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_col_inpwn_attach_info where 0=1;


-- 第一组（共六组）其他质押物
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999'  	                         -- 法人编号
   ,t1.sccode                          -- 押品编号
   ,t1.guarname                        -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,t1.amount                          -- 质押数量
   ,t2.amt                             -- 押品原值
   ,substr(t1.remark, 1, 200)          -- 其他说明
   ,'SI_OTHERPLEDGE'                   --专项信息类型代码
   ,'mimsf1'                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mims_si_otherpledge t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.sccode = t2.sccode
where t1.sccode in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第二组（共六组）资产池信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999'  	                         -- 法人编号
   ,t1.sccode                          -- 押品编号
   ,t2.guarinfoname                    -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,''                                 -- 质押数量
   ,t1.poolmoney                       -- 押品原值
   ,substr(t1.remark, 1, 200)          -- 其他说明
   ,'SI_ASSETPOOL'                      --专项信息类型代码
   ,'mimsf2'                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mims_si_assetpool t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.sccode = t2.sccode
where t1.sccode in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第三组（共六组）应收租金信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.asset_id                        -- 押品编号
   ,t2.guarinfoname                    -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,''                                 -- 质押数量
   ,t2.amt                             -- 押品原值
   ,substr(t1.other_comnt, 1, 200)     -- 其他说明
   ,'SI_RENT'                          --专项信息类型代码
   ,'mimsf3'                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.ast_col_recvbl_rent_info t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.asset_id = t2.sccode
where t1.asset_id in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mimsf1'
  and t1.id_mark <> 'D'
;
commit;

-- 第四组（共六组）收费权信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999'  	                         -- 法人编号
   ,t1.sccode                          -- 押品编号
   ,t2.guarinfoname                    -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,''                                 -- 质押数量
   ,t2.amt                             -- 押品原值
   ,substr(t1.remark, 1, 200)          -- 其他说明
   ,'SI_TOLL'                          --专项信息类型代码
   ,'mimsf4'                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mims_si_toll t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.sccode = t2.sccode
where t1.sccode in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第五组（共六组）出口退税信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.asset_id                        -- 押品编号
   ,t2.guarinfoname                    -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,''                                 -- 质押数量
   ,t1.exp_tax_rebate_amt              -- 押品原值
   ,substr(t1.other_comnt, 1, 200)     -- 其他说明
   ,'SI_EXPORTREBATES'                 --专项信息类型代码
   ,'mimsf5'                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.ast_col_exp_tax_rebate_info t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.asset_id = t2.sccode
where t1.asset_id in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mimsf1'
  and t1.id_mark <> 'D'
;
commit;

-- 第六组（共八组）票据池信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,col_id                             -- 押品编号
   ,col_name                           -- 押品名称
   ,wat_id                             -- 权证编号
   ,inpwn_qtty                         -- 质押数量
   ,col_cost                           -- 押品原值
   ,other_comnt                        -- 其他说明
   ,spcl_info_type_cd                 --专项信息类型代码
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,'9999'  	                         -- 法人编号
   ,t1.sccode                          -- 押品编号
   ,t2.guarinfoname                    -- 押品名称
   ,t2.warrantsno                      -- 权证编号
   ,t1.billnumber                      -- 质押数量
   ,t1.money                           -- 押品原值
   ,substr(t1.remark, 1, 200)          -- 其他说明
   ,'SI_BAILPOOLS'                     --专项信息类型代码
   ,'mimsf6'                           -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.mims_si_bailpools t1
 left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2
   on t1.sccode = t2.sccode
where t1.sccode in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

--第七组（共八组）本行理财产品
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
  etl_dt              --数据日期
  ,lp_id               --法人编号
  ,col_id              --押品编号
  ,col_name            --押品名称
  ,wat_id              --权证编号
  ,inpwn_qtty          --质押数量
  ,col_cost            --押品原值
  ,other_comnt         --其他说明
  ,spcl_info_type_cd   --专项信息类型代码
  ,job_cd                             -- 任务代码
  ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id
   ,t1.asset_id         --押品编号
   ,t2.guarinfoname      --押品名称
   ,t2.warrantsno        --权证编号
   ,''                   --质押数量
   ,t1.tot_lot           --押品原值
   ,substr(t1.remark, 1, 200)    --其他说明
   ,'SI_OWNERFINANCIAL'             --专项信息类型代码
   ,'mimsf7'                           -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from
${iml_schema}.ast_ghb_finc_prod_inpwn_info t1	 
left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2			
on t1.asset_id = t2.sccode			
where t1.asset_id in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
and t1.job_cd = 'mimsf1'
and t1.id_mark <> 'D'
;
commit;

--第八组（共八组）他行理财产品
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_inpwn_attach_info_ex(
  etl_dt              --数据日期
  ,lp_id               --法人编号
  ,col_id              --押品编号
  ,col_name            --押品名称
  ,wat_id              --权证编号
  ,inpwn_qtty          --质押数量
  ,col_cost            --押品原值
  ,other_comnt         --其他说明
  ,spcl_info_type_cd   --专项信息类型代码
  ,job_cd                             -- 任务代码
  ,etl_timestamp                      -- etl处理时间戳
)
select 
   to_date('${batch_date}','yyyymmdd')
   ,'9999'
   ,t1.sccode         --押品编号
   ,t2.guarinfoname   --押品名称
   ,t2.warrantsno     --权证编号
   ,''                --质押数量
   ,t1.allnum         --押品原值
   ,substr(t1.remark, 1, 200)   --其他说明
   ,'SI_OTHERFINANCIAL'         --专项信息类型代码
   ,'mimsf8'                           -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from ${iol_schema}.mims_si_otherfinancial t1
left join ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 t2	
on t1.sccode = t2.sccode
where t1.sccode in (select acbi.asset_id from ${iml_schema}.ast_col_basic_info acbi
                                   where acbi.create_dt <= to_date('${batch_date}','yyyymmdd')
                                     and acbi.job_cd = 'mimsf1'
                                     and acbi.id_mark <> 'D')
     and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	 and t1.id_mark <> 'D'
;
commit;	


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_col_inpwn_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_col_inpwn_attach_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_col_inpwn_attach_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_col_inpwn_attach_info_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_col_inpwn_attach_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);