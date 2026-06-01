/*
Purpose:  共性加工层-发行人评级信息
Author:   Sunline
Usage:   python $ETL_HOME/script/main.py yyyymmdd icl_cmm_issuer_rating_info
CreateDate: 20190808
Logs:    20200925 周沁晖 增加字段【评级公司中文名称】
                         增加第二组逻辑
         20210619 陈伟峰  1、增加字段【发行人客户编号、源系统代码】
                          2、增加第三组【同业系统发行人评级】
         20220525 陈伟峰  调整字段【发行人编号】取值逻辑
         20231106 徐子豪  新增第三组同业评级（业务手工认定），将原来的第三组调整为第四组，同时调整第四组数据范围，优先取第三组评级数据，取不到才取第四组,调整【TBS_VS_CPTYS.ISLINK_SRC是否连接电子证书】限制条件打Y
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_issuer_rating_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_issuer_rating_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_issuer_rating_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_issuer_rating_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_issuer_rating_info where 0=1;

--第一组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_issuer_rating_info_ex(
   etl_dt            -- 数据日期
   ,lp_id            -- 法人编号
   ,issuer_id        -- 发行人编号
   ,issuer_cust_id   -- 发行人客户编号
   ,issuer_cn_name   -- 发行人中文名称
   ,issuer_en_name   -- 发行人英文名称
   ,rating_corp_id   -- 评级公司编号
   ,rating_corp_cn_name -- 评级公司中文名称
   ,rating_rest_cd   -- 评级结果代码
   ,rating_type_cd   -- 评级类型代码
   ,rating_dt        -- 评级日期
   ,sorc_sys_cd      -- 源系统代码
   ,job_cd           -- 任务代码
   ,etl_timestamp    -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')  -- 数据日期
   ,t1.lp_id             -- 法人编号
   ,t1.issuer_id         -- 发行人编号
   ,t4.cust_id           -- 发行人客户编号
   ,t2.cn_name           -- 中文名称
   ,t2.en_name           -- 英文名称
   ,t1.rating_org_id     -- 评级公司编号
   ,t3.rating_org_cn_name-- 评级公司中文名称
   ,t1.rating_level      -- 评级结果代码
   ,t1.rating_cate_cd    -- 评级类型代码
   ,t1.rating_dt         -- 评级日期
   ,'CTMS'               -- 源系统代码
   ,t1.job_cd            -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.pty_bond_issuer_rating_h t1 --债券发行人评级历史
  left join ${iml_schema}.pty_bond_issuer_info t2 --债券发行人信息
    on t1.issuer_id = t2.issuer_id
   and t2.job_cd = 'ctmsf1'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
  left join ${iml_schema}.pty_bond_rating_org t3
    on t1.rating_org_id = t3.rating_org_id
   and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
  left join ${iml_schema}.pty_cap_cntpty_info t4
    on t1.issuer_id = t4.issuer_id
   and t4.elec_cert_flg ='Y'
   and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ctmsf1'
   and t4.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsf1'
;
commit;

--第二组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_issuer_rating_info_ex(
   etl_dt            -- 数据日期
   ,lp_id            -- 法人编号
   ,issuer_id        -- 发行人编号
   ,issuer_cust_id   -- 发行人客户编号
   ,issuer_cn_name   -- 发行人中文名称
   ,issuer_en_name   -- 发行人英文名称
   ,rating_corp_id   -- 评级公司编号
   ,rating_corp_cn_name -- 评级公司中文名称
   ,rating_rest_cd   -- 评级结果代码
   ,rating_type_cd   -- 评级类型代码
   ,rating_dt        -- 评级日期
   ,sorc_sys_cd      -- 源系统代码
   ,job_cd           -- 任务代码
   ,etl_timestamp    -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')  -- 数据日期
   ,t1.lp_id             -- 法人编号
   ,t1.issuer_id         -- 发行人编号
   ,t1.cust_id           -- 发行人客户编号
   ,t12.party_name       -- 中文名称
   ,t11.party_name       -- 英文名称
   ,t3.attr_val          -- 评级公司编号
   ,t3.attr_val_descb    -- 评级公司中文名称
   ,t2.attr_val_descb    -- 评级结果代码
   ,'0'                  -- 评级类型代码
   ,''                   -- 评级日期
   ,'CTMS'               -- 源系统代码
   ,t1.job_cd            -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.pty_fcurr_bond_party t1 --外币债当事人
  left join ${iml_schema}.pty_party_name_h t11 --当事人名称历史
    on t1.party_id = t11.party_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'ctmsf2'
   and t11.src_sys_cd = 'CTMS'
   and t11.party_name_type_cd = '06'
  left join ${iml_schema}.pty_party_name_h t12 --当事人名称历史
    on t1.party_id = t12.party_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'ctmsf2'
   and t12.src_sys_cd = 'CTMS'
   and t12.party_name_type_cd = '02'
  left join ${iml_schema}.pty_fcurr_bond_attr_h t2 --外币债当事人属性历史
    on t1.party_id = t2.party_id
   and t2.job_cd = 'ctmsf2'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.attr_name = 'FRATING'
  left join ${iml_schema}.pty_fcurr_bond_attr_h t3 --外币债当事人属性历史
    on t1.party_id = t3.party_id
   and t3.job_cd = 'ctmsf2'
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.attr_name = 'FRATINGORG'
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsf2'
   and t1.id_mark <> 'D'
   and t1.issuer_flg = '1'
;
commit;

--第三组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_issuer_rating_info_ex(
   etl_dt               -- 数据日期
   ,lp_id               -- 法人编号
   ,issuer_id           -- 发行人编号
   ,issuer_cust_id      -- 发行人客户编号
   ,issuer_cn_name      -- 发行人中文名称
   ,issuer_en_name      -- 发行人英文名称
   ,rating_corp_id      -- 评级公司编号
   ,rating_corp_cn_name -- 评级公司中文名称
   ,rating_rest_cd      -- 评级结果代码
   ,rating_type_cd      -- 评级类型代码
   ,rating_dt           -- 评级日期
   ,sorc_sys_cd         -- 源系统代码
   ,job_cd              -- 任务代码
   ,etl_timestamp       -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                     -- 数据日期
   ,t1.lp_id                                               -- 法人编号
   ,t1.issuer_id                                           -- 发行人编号
   ,t3.cust_id                                             -- 发行人客户编号
   ,t3.party_fname                                         -- 中文名称
   ,''                                                     -- 英文名称
   ,''                                                     -- 评级公司编号
   ,t1.hx_inst_grade_org                                   -- 评级公司中文名称
   ,t1.hx_inst_grade                                       -- 评级结果代码
   ,'0'                                                    -- 评级类型代码
   ,t1.hx_grade_date_inst                                  -- 评级日期
   ,'IBMS'                                                 -- 源系统代码
   ,'ibmsf1'                                               -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from (select t2.lp_id
            ,t2.issuer_id
            ,t1.hx_inst_grade_org
            ,t1.hx_inst_grade
            ,to_date(trim(t1.hx_grade_date_inst),'yyyy-mm-dd') as hx_grade_date_inst
            ,row_number()over(partition by t2.issuer_id,t1.hx_grade_date_inst order by t1.hx_inst_grade desc) as rn
     from ${iol_schema}.ibms_trpt_tbnd_ext t1
     inner join ${iml_schema}.prd_ibank_bond t2 on t1.i_code = t2.fin_instm_id
        and t1.a_type = t2.asset_type_id
        and t1.m_type = t2.market_type_id
        and t2.market_type_id <> 'X_CNBD'
        and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
        and t2.job_cd = 'ibmsf1'
        and t2.id_mark <> 'D'
     where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
       and t1.end_dt > to_date('${batch_date}','yyyymmdd')) t1
left join ${iml_schema}.pty_ibank_cntpty_info t3 on t1.issuer_id = t3.src_party_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
   where t1.rn = 1
;
commit;


--第四组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_issuer_rating_info_ex(
   etl_dt               -- 数据日期
   ,lp_id               -- 法人编号
   ,issuer_id           -- 发行人编号
   ,issuer_cust_id      -- 发行人客户编号
   ,issuer_cn_name      -- 发行人中文名称
   ,issuer_en_name      -- 发行人英文名称
   ,rating_corp_id      -- 评级公司编号
   ,rating_corp_cn_name -- 评级公司中文名称
   ,rating_rest_cd      -- 评级结果代码
   ,rating_type_cd      -- 评级类型代码
   ,rating_dt           -- 评级日期
   ,sorc_sys_cd         -- 源系统代码
   ,job_cd              -- 任务代码
   ,etl_timestamp       -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')  -- 数据日期
   ,'9999'                              -- 法人编号
   ,t1.comp_id                          -- 发行人编号
   ,t2.cust_id                          -- 发行人客户编号
   ,t2.party_fname                      -- 中文名称
   ,''                                  -- 英文名称
   ,''                                  -- 评级公司编号
   ,t1.rating_institution               -- 评级公司中文名称
   ,t1.s_grade                          -- 评级结果代码
   ,'0'                                 -- 评级类型代码
   ,''                                  -- 评级日期
   ,'IBMS'                              -- 源系统代码
   ,'ibmsf1'                            -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iol_schema}.ibms_tinstrument_comp_grade t1
  left join ${iml_schema}.pty_ibank_cntpty_info t2
   on t1.comp_id = t2.src_party_id
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'ibmsf1'
  and t2.id_mark <> 'D'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and not exists (select 1 from icl.cmm_issuer_rating_info_ex t3 where t1.comp_id = t3.issuer_id)
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_issuer_rating_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_issuer_rating_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_issuer_rating_info_ex purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_issuer_rating_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
