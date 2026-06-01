/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_dep_vouch_cate_para_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_dep_vouch_cate_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_vouch_cate_para partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_vouch_cate_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_vouch_cate_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_vouch_cate_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_tb_voucher_def-1
insert into ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm(
    dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.DOC_TYPE -- 存款凭证类别代码
    ,'9999' -- 法人编号
    ,P1.DOC_TYPE_DESC -- 凭证类型描述
    ,P1.DOC_CLASS -- 凭证形式代码
    ,DECODE(P1.VOUCHER_BILL_IND,'C','1','V','0') -- 凭证票据标识代码
    ,NVL(TRIM(P1.VOUCHER_LENGTH),0) -- 凭证编号长度
    ,DECODE(P1.PREFIX_REQ,'Y','1','N','0') -- 有前缀标志
    ,decode(trim(p1.IS_CASH_CHEQUE),'','-','Y','1','N','0',p1.IS_CASH_CHEQUE) -- 现金支票标志
    ,DECODE(P1.IS_CHEQUE_BOOK,'Y','1','N','0') -- 支票标志
    ,DECODE(P1.HAVE_NUMBER,'Y','1','N','0') -- 有号标志
    ,DECODE(P1.IN_CONTRAL,'Y','1','N','0') -- 总行入库标志
    ,DECODE(P1.BRANCH_RESTRAINT_FLAG,'Y','1','N','0') -- 限制机构使用标志
    ,DECODE(P1.ALLOW_DISTR_FLAG,'Y','1','N','0') -- 允许调拨标志
    ,DECODE(P1.SALE_FLAG,'Y','1','N','0') -- 出售许可标志
    ,P1.VOU_LOST_DAYS -- 口挂天数
    ,P1.VOU_LOST_REISSUE_DAYS -- 挂失补发天数
    ,P1.COMMISSION_VOU_LOST_DAYS -- 代办人口挂天数
    ,P1.EXPIRE_DATE -- 失效日期
    ,P1.EFFECT_DATE -- 生效日期
    ,DECODE(P1.USE_BY_ORDER_FLAG,'Y','1','N','0') -- 按顺序使用标志
    ,nvl(trim(P1.DEPOSIT_TYPE),'-') -- 存款类别代码
    ,DECODE(P1.OTHER_BANK_FLAG,'Y','1','N','0') -- 他行票据标志
    ,DECODE(P1.VOUCHER_APPROVE_STATUS,'E','1','A','0') -- 批准标志
    ,decode(trim(p1.ALLOW_CHEQUE_DENOM_FLAG),'','-','Y','1','N','0',p1.ALLOW_CHEQUE_DENOM_FLAG) -- 有价单证固定面额标志
    ,P1.TC_DENOM_GROUP -- 有价单证固定面额组
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_tb_voucher_def' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_tb_voucher_def p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm 
  	                                group by 
  	                                        dep_vouch_cate_cd
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl(
            dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op(
            dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dep_vouch_cate_cd, o.dep_vouch_cate_cd) as dep_vouch_cate_cd -- 存款凭证类别代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vouch_type_descb, o.vouch_type_descb) as vouch_type_descb -- 凭证类型描述
    ,nvl(n.vouch_form_cd, o.vouch_form_cd) as vouch_form_cd -- 凭证形式代码
    ,nvl(n.vouch_bill_idf_cd, o.vouch_bill_idf_cd) as vouch_bill_idf_cd -- 凭证票据标识代码
    ,nvl(n.vouch_id_length, o.vouch_id_length) as vouch_id_length -- 凭证编号长度
    ,nvl(n.have_prefix_flg, o.have_prefix_flg) as have_prefix_flg -- 有前缀标志
    ,nvl(n.cash_check_flg, o.cash_check_flg) as cash_check_flg -- 现金支票标志
    ,nvl(n.check_flg, o.check_flg) as check_flg -- 支票标志
    ,nvl(n.have_num_flg, o.have_num_flg) as have_num_flg -- 有号标志
    ,nvl(n.hq_insto_flg, o.hq_insto_flg) as hq_insto_flg -- 总行入库标志
    ,nvl(n.lmt_org_use_flg, o.lmt_org_use_flg) as lmt_org_use_flg -- 限制机构使用标志
    ,nvl(n.allow_cannib_flg, o.allow_cannib_flg) as allow_cannib_flg -- 允许调拨标志
    ,nvl(n.sell_permit_flg, o.sell_permit_flg) as sell_permit_flg -- 出售许可标志
    ,nvl(n.mou_hange_days, o.mou_hange_days) as mou_hange_days -- 口挂天数
    ,nvl(n.loss_reissue_days, o.loss_reissue_days) as loss_reissue_days -- 挂失补发天数
    ,nvl(n.public_agent_mou_hange_days, o.public_agent_mou_hange_days) as public_agent_mou_hange_days -- 代办人口挂天数
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.accrd_seq_use_flg, o.accrd_seq_use_flg) as accrd_seq_use_flg -- 按顺序使用标志
    ,nvl(n.dep_cate_cd, o.dep_cate_cd) as dep_cate_cd -- 存款类别代码
    ,nvl(n.obank_bill_flg, o.obank_bill_flg) as obank_bill_flg -- 他行票据标志
    ,nvl(n.apprv_flg, o.apprv_flg) as apprv_flg -- 批准标志
    ,nvl(n.have_price_doc_fix_denom_flg, o.have_price_doc_fix_denom_flg) as have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,nvl(n.have_price_doc_fix_denom_group, o.have_price_doc_fix_denom_group) as have_price_doc_fix_denom_group -- 有价单证固定面额组
    ,case when
            n.dep_vouch_cate_cd is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dep_vouch_cate_cd is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dep_vouch_cate_cd is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.dep_vouch_cate_cd = n.dep_vouch_cate_cd
            and o.lp_id = n.lp_id
where (
        o.dep_vouch_cate_cd is null
        and o.lp_id is null
    )
    or (
        n.dep_vouch_cate_cd is null
        and n.lp_id is null
    )
    or (
        o.vouch_type_descb <> n.vouch_type_descb
        or o.vouch_form_cd <> n.vouch_form_cd
        or o.vouch_bill_idf_cd <> n.vouch_bill_idf_cd
        or o.vouch_id_length <> n.vouch_id_length
        or o.have_prefix_flg <> n.have_prefix_flg
        or o.cash_check_flg <> n.cash_check_flg
        or o.check_flg <> n.check_flg
        or o.have_num_flg <> n.have_num_flg
        or o.hq_insto_flg <> n.hq_insto_flg
        or o.lmt_org_use_flg <> n.lmt_org_use_flg
        or o.allow_cannib_flg <> n.allow_cannib_flg
        or o.sell_permit_flg <> n.sell_permit_flg
        or o.mou_hange_days <> n.mou_hange_days
        or o.loss_reissue_days <> n.loss_reissue_days
        or o.public_agent_mou_hange_days <> n.public_agent_mou_hange_days
        or o.invalid_dt <> n.invalid_dt
        or o.effect_dt <> n.effect_dt
        or o.accrd_seq_use_flg <> n.accrd_seq_use_flg
        or o.dep_cate_cd <> n.dep_cate_cd
        or o.obank_bill_flg <> n.obank_bill_flg
        or o.apprv_flg <> n.apprv_flg
        or o.have_price_doc_fix_denom_flg <> n.have_price_doc_fix_denom_flg
        or o.have_price_doc_fix_denom_group <> n.have_price_doc_fix_denom_group
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl(
            dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op(
            dep_vouch_cate_cd -- 存款凭证类别代码
    ,lp_id -- 法人编号
    ,vouch_type_descb -- 凭证类型描述
    ,vouch_form_cd -- 凭证形式代码
    ,vouch_bill_idf_cd -- 凭证票据标识代码
    ,vouch_id_length -- 凭证编号长度
    ,have_prefix_flg -- 有前缀标志
    ,cash_check_flg -- 现金支票标志
    ,check_flg -- 支票标志
    ,have_num_flg -- 有号标志
    ,hq_insto_flg -- 总行入库标志
    ,lmt_org_use_flg -- 限制机构使用标志
    ,allow_cannib_flg -- 允许调拨标志
    ,sell_permit_flg -- 出售许可标志
    ,mou_hange_days -- 口挂天数
    ,loss_reissue_days -- 挂失补发天数
    ,public_agent_mou_hange_days -- 代办人口挂天数
    ,invalid_dt -- 失效日期
    ,effect_dt -- 生效日期
    ,accrd_seq_use_flg -- 按顺序使用标志
    ,dep_cate_cd -- 存款类别代码
    ,obank_bill_flg -- 他行票据标志
    ,apprv_flg -- 批准标志
    ,have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group -- 有价单证固定面额组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dep_vouch_cate_cd -- 存款凭证类别代码
    ,o.lp_id -- 法人编号
    ,o.vouch_type_descb -- 凭证类型描述
    ,o.vouch_form_cd -- 凭证形式代码
    ,o.vouch_bill_idf_cd -- 凭证票据标识代码
    ,o.vouch_id_length -- 凭证编号长度
    ,o.have_prefix_flg -- 有前缀标志
    ,o.cash_check_flg -- 现金支票标志
    ,o.check_flg -- 支票标志
    ,o.have_num_flg -- 有号标志
    ,o.hq_insto_flg -- 总行入库标志
    ,o.lmt_org_use_flg -- 限制机构使用标志
    ,o.allow_cannib_flg -- 允许调拨标志
    ,o.sell_permit_flg -- 出售许可标志
    ,o.mou_hange_days -- 口挂天数
    ,o.loss_reissue_days -- 挂失补发天数
    ,o.public_agent_mou_hange_days -- 代办人口挂天数
    ,o.invalid_dt -- 失效日期
    ,o.effect_dt -- 生效日期
    ,o.accrd_seq_use_flg -- 按顺序使用标志
    ,o.dep_cate_cd -- 存款类别代码
    ,o.obank_bill_flg -- 他行票据标志
    ,o.apprv_flg -- 批准标志
    ,o.have_price_doc_fix_denom_flg -- 有价单证固定面额标志
    ,o.have_price_doc_fix_denom_group -- 有价单证固定面额组
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_bk o
    left join ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op n
        on
            o.dep_vouch_cate_cd = n.dep_vouch_cate_cd
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl d
        on
            o.dep_vouch_cate_cd = d.dep_vouch_cate_cd
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_dep_vouch_cate_para;
--alter table ${iml_schema}.ref_dep_vouch_cate_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_dep_vouch_cate_para') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_dep_vouch_cate_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_dep_vouch_cate_para modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_dep_vouch_cate_para exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl;
alter table ${iml_schema}.ref_dep_vouch_cate_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_dep_vouch_cate_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_dep_vouch_cate_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_dep_vouch_cate_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
