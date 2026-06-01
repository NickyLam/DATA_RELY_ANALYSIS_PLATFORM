/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ref_vouch_para
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
alter table ${itl_schema}.itl_edw_ref_vouch_para drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ref_vouch_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ref_vouch_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ref_vouch_para partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,vouch_kind_cd  -- 凭证种类代码
    ,vouch_name  -- 凭证名称
    ,vouch_abbr  -- 凭证简称
    ,vouch_char_cd  -- 凭证性质代码
    ,vouch_form_cd  -- 凭证形式代码
    ,vouch_id_length  -- 凭证编号长度
    ,vouch_batch_no_length  -- 凭证批号长度
    ,curr_batch_no  -- 当前批号
    ,each_this_vouch_qtty  -- 每本凭证数量
    ,tran_vouch_type_cd  -- 交易凭证类型代码
    ,ghb_vouch_flg  -- 本行凭证标志
    ,invtry_mgmt_flg  -- 库存管理标志
    ,sell_permit_flg  -- 出售许可标志
    ,buy_org_ctrl_cd  -- 购入机构控制代码
    ,porf_flg  -- 有价证券标志
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'')  -- 凭证种类代码
    ,replace(replace(t1.vouch_name,chr(13),''),chr(10),'')  -- 凭证名称
    ,replace(replace(t1.vouch_abbr,chr(13),''),chr(10),'')  -- 凭证简称
    ,replace(replace(t1.vouch_char_cd,chr(13),''),chr(10),'')  -- 凭证性质代码
    ,replace(replace(t1.vouch_form_cd,chr(13),''),chr(10),'')  -- 凭证形式代码
    ,t1.vouch_id_length  -- 凭证编号长度
    ,t1.vouch_batch_no_length  -- 凭证批号长度
    ,replace(replace(t1.curr_batch_no,chr(13),''),chr(10),'')  -- 当前批号
    ,t1.each_this_vouch_qtty  -- 每本凭证数量
    ,replace(replace(t1.tran_vouch_type_cd,chr(13),''),chr(10),'')  -- 交易凭证类型代码
    ,replace(replace(t1.ghb_vouch_flg,chr(13),''),chr(10),'')  -- 本行凭证标志
    ,replace(replace(t1.invtry_mgmt_flg,chr(13),''),chr(10),'')  -- 库存管理标志
    ,replace(replace(t1.sell_permit_flg,chr(13),''),chr(10),'')  -- 出售许可标志
    ,replace(replace(t1.buy_org_ctrl_cd,chr(13),''),chr(10),'')  -- 购入机构控制代码
    ,replace(replace(t1.porf_flg,chr(13),''),chr(10),'')  -- 有价证券标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_ref_vouch_para t1    --凭证参数表
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ref_vouch_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);