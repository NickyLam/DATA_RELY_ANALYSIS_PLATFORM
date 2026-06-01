/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_log_info_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_log_info_isbsf1_tm purge;
drop table ${iml_schema}.agt_log_info_isbsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_log_info add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_log_info modify partition p_isbsf1
    add subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_log_info_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_log_info partition for ('isbsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_log_info_isbsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,log_bus_id -- 保函业务编号
    ,tran_descb -- 交易描述
    ,log_effect_dt -- 保函生效日期
    ,full_amt_pay_dt -- 全额付款日期
    ,indent_dt -- 订单日期
    ,log_invalid_dt -- 保函失效日期
    ,cty_rg_cd -- 国家和地区代码
    ,edit_id -- 版本编号
    ,log_open_type_cd -- 保函开立类型代码
    ,cont_id -- 合同编号
    ,cancel_rs_cd -- 取消原因代码
    ,decrs_lmt_amt -- 减额金额
    ,decrs_lmt_curr_cd -- 减额币种代码
    ,decrs_lmt_dt -- 减额日期
    ,bal_curr_cd -- 余额币种代码
    ,bal -- 余额
    ,acpt_flg -- 承兑标志
    ,acpt_ratio -- 承兑比例
    ,open_dt -- 开立日期
    ,acpt_way_cd -- 承兑方式代码
    ,log_kind_cd -- 保函种类代码
    ,charge_dt -- 收费日期
    ,tran_org_id -- 交易机构编号
    ,belong_org_id -- 所属机构编号
    ,decrs_lmt_flg -- 减额标志
    ,margin_recvbl_ratio -- 保证金应收比例
    ,mtg_bus_flg -- 货押业务标志
    ,dubil_id -- 借据编号
    ,margin_actl_recv_ratio -- 保证金实收比例
    ,fin_log_flg -- 融资性保函标志
    ,open_type_cd -- 开立类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_log_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_log_info_isbsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_log_info partition for ('isbsf1') where 0=1;

-- 2.1 insert data to tm table
-- isbs_gid
insert into ${iml_schema}.agt_log_info_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,log_bus_id -- 保函业务编号
    ,tran_descb -- 交易描述
    ,log_effect_dt -- 保函生效日期
    ,full_amt_pay_dt -- 全额付款日期
    ,indent_dt -- 订单日期
    ,log_invalid_dt -- 保函失效日期
    ,cty_rg_cd -- 国家和地区代码
    ,edit_id -- 版本编号
    ,log_open_type_cd -- 保函开立类型代码
    ,cont_id -- 合同编号
    ,cancel_rs_cd -- 取消原因代码
    ,decrs_lmt_amt -- 减额金额
    ,decrs_lmt_curr_cd -- 减额币种代码
    ,decrs_lmt_dt -- 减额日期
    ,bal_curr_cd -- 余额币种代码
    ,bal -- 余额
    ,acpt_flg -- 承兑标志
    ,acpt_ratio -- 承兑比例
    ,open_dt -- 开立日期
    ,acpt_way_cd -- 承兑方式代码
    ,log_kind_cd -- 保函种类代码
    ,charge_dt -- 收费日期
    ,tran_org_id -- 交易机构编号
    ,belong_org_id -- 所属机构编号
    ,decrs_lmt_flg -- 减额标志
    ,margin_recvbl_ratio -- 保证金应收比例
    ,mtg_bus_flg -- 货押业务标志
    ,dubil_id -- 借据编号
    ,margin_actl_recv_ratio -- 保证金实收比例
    ,fin_log_flg -- 融资性保函标志
    ,open_type_cd -- 开立类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '226303'|| P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 源协议编号
    ,P1.OWNREF -- 保函业务编号
    ,P1.NAM -- 交易描述
    ,P1.OPNDAT -- 保函生效日期
    ,P1.CLSDAT -- 全额付款日期
    ,P1.ORDDAT -- 订单日期
    ,P1.EXPDAT -- 保函失效日期
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else substr('@'|| P1.STACTY,1,30) end  -- 国家和地区代码
    ,P1.VER -- 版本编号
    ,nvl(trim(P1.HNDTYP),'-') -- 保函开立类型代码
    ,P1.ORCREF -- 合同编号
    ,nvl(trim(P1.PURCAN),'-') -- 取消原因代码
    ,P1.REDAMT -- 减额金额
    ,nvl(trim(P1.REDCUR),'-') -- 减额币种代码
    ,P1.REDDAT -- 减额日期
    ,nvl(trim(P1.OUTCUR),'-') -- 余额币种代码
    ,P1.OUTAMT -- 余额
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else substr('@'|| P1.CNFSTA,1,10) end -- 承兑标志
    ,P1.PARTCON -- 承兑比例
    ,P1.CNFDAT -- 开立日期
    ,nvl(trim(P1.CNFFLG),'-') -- 承兑方式代码
    ,case when R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL else substr('@'|| P1.GARTYP,1,30) end -- 保函种类代码
    ,P1.FEECOLDAT -- 收费日期
    ,case when trim(P2.BRANCH) is not null then P2.BRANCH else P1.BCHKEYINR end -- 交易机构编号
    ,case when trim(P3.BRANCH) is not null then P3.BRANCH else P1.BRANCHINR end -- 所属机构编号
    ,case when R4.TARGET_CD_VAL is not null then R4.TARGET_CD_VAL else substr('@'|| P1.DECFLG,1,10) end -- 减额标志
    ,P1.CSHPCT -- 保证金应收比例
    ,P1.GUAFLG -- 货押业务标志
    ,P1.FINCOD -- 借据编号
    ,P1.RELCSHPCT -- 保证金实收比例
    ,case when R5.TARGET_CD_VAL is not null then R5.TARGET_CD_VAL else substr('@'|| P1.GARFIN,1,10) end -- 融资性保函标志
    ,P1.PURPOS -- 开立类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_gid' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_gid p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STACTY=R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD='ISBS'
AND R1.SRC_TAB_EN_NAME='ISBS_GID'
AND R1.SRC_FIELD_EN_NAME='STACTY'
AND R1.TARGET_TAB_EN_NAME='AGT_LOG_INFO'
AND R1.TARGET_TAB_FIELD_EN_NAME='CTY_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CNFSTA=R2.SRC_CODE_VAL
AND R2.SORC_SYS_CD='ISBS'
AND R2.SRC_TAB_EN_NAME='ISBS_GID'
AND R2.SRC_FIELD_EN_NAME='CNFSTA'
AND R2.TARGET_TAB_EN_NAME='AGT_LOG_INFO'
AND R2.TARGET_TAB_FIELD_EN_NAME='ACPT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.GARTYP=R3.SRC_CODE_VAL
AND R3.SORC_SYS_CD='ISBS'
AND R3.SRC_TAB_EN_NAME='ISBS_GID'
AND R3.SRC_FIELD_EN_NAME='GARTYP'
AND R3.TARGET_TAB_EN_NAME='AGT_LOG_INFO'
AND R3.TARGET_TAB_FIELD_EN_NAME='LOG_KIND_CD'
    left join ${iol_schema}.isbs_bch p2 on P1.BCHKEYINR=P2.inr
and P2.start_dt <= to_date('${batch_date}','yyyymmdd') and P2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BRANCHINR=P3.inr
and P3.start_dt <= to_date('${batch_date}','yyyymmdd') and P3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DECFLG=R4.SRC_CODE_VAL
AND R4.SORC_SYS_CD='ISBS'
AND R4.SRC_TAB_EN_NAME='ISBS_GID'
AND R4.SRC_FIELD_EN_NAME='DECFLG'
AND R4.TARGET_TAB_EN_NAME='AGT_LOG_INFO'
AND R4.TARGET_TAB_FIELD_EN_NAME='DECRS_LMT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.GARFIN=R5.SRC_CODE_VAL
AND R5.SORC_SYS_CD='ISBS'
AND R5.SRC_TAB_EN_NAME='ISBS_GID'
AND R5.SRC_FIELD_EN_NAME='GARFIN'
AND R5.TARGET_TAB_EN_NAME='AGT_LOG_INFO'
AND R5.TARGET_TAB_FIELD_EN_NAME='FIN_LOG_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_log_info_isbsf1_tm 
  	                                group by 
  	                                        agt_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_log_info_isbsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,log_bus_id -- 保函业务编号
    ,tran_descb -- 交易描述
    ,log_effect_dt -- 保函生效日期
    ,full_amt_pay_dt -- 全额付款日期
    ,indent_dt -- 订单日期
    ,log_invalid_dt -- 保函失效日期
    ,cty_rg_cd -- 国家和地区代码
    ,edit_id -- 版本编号
    ,log_open_type_cd -- 保函开立类型代码
    ,cont_id -- 合同编号
    ,cancel_rs_cd -- 取消原因代码
    ,decrs_lmt_amt -- 减额金额
    ,decrs_lmt_curr_cd -- 减额币种代码
    ,decrs_lmt_dt -- 减额日期
    ,bal_curr_cd -- 余额币种代码
    ,bal -- 余额
    ,acpt_flg -- 承兑标志
    ,acpt_ratio -- 承兑比例
    ,open_dt -- 开立日期
    ,acpt_way_cd -- 承兑方式代码
    ,log_kind_cd -- 保函种类代码
    ,charge_dt -- 收费日期
    ,tran_org_id -- 交易机构编号
    ,belong_org_id -- 所属机构编号
    ,decrs_lmt_flg -- 减额标志
    ,margin_recvbl_ratio -- 保证金应收比例
    ,mtg_bus_flg -- 货押业务标志
    ,dubil_id -- 借据编号
    ,margin_actl_recv_ratio -- 保证金实收比例
    ,fin_log_flg -- 融资性保函标志
    ,open_type_cd -- 开立类型代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.log_bus_id, o.log_bus_id) as log_bus_id -- 保函业务编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.log_effect_dt, o.log_effect_dt) as log_effect_dt -- 保函生效日期
    ,nvl(n.full_amt_pay_dt, o.full_amt_pay_dt) as full_amt_pay_dt -- 全额付款日期
    ,nvl(n.indent_dt, o.indent_dt) as indent_dt -- 订单日期
    ,nvl(n.log_invalid_dt, o.log_invalid_dt) as log_invalid_dt -- 保函失效日期
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家和地区代码
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,nvl(n.log_open_type_cd, o.log_open_type_cd) as log_open_type_cd -- 保函开立类型代码
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.cancel_rs_cd, o.cancel_rs_cd) as cancel_rs_cd -- 取消原因代码
    ,nvl(n.decrs_lmt_amt, o.decrs_lmt_amt) as decrs_lmt_amt -- 减额金额
    ,nvl(n.decrs_lmt_curr_cd, o.decrs_lmt_curr_cd) as decrs_lmt_curr_cd -- 减额币种代码
    ,nvl(n.decrs_lmt_dt, o.decrs_lmt_dt) as decrs_lmt_dt -- 减额日期
    ,nvl(n.bal_curr_cd, o.bal_curr_cd) as bal_curr_cd -- 余额币种代码
    ,nvl(n.bal, o.bal) as bal -- 余额
    ,nvl(n.acpt_flg, o.acpt_flg) as acpt_flg -- 承兑标志
    ,nvl(n.acpt_ratio, o.acpt_ratio) as acpt_ratio -- 承兑比例
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开立日期
    ,nvl(n.acpt_way_cd, o.acpt_way_cd) as acpt_way_cd -- 承兑方式代码
    ,nvl(n.log_kind_cd, o.log_kind_cd) as log_kind_cd -- 保函种类代码
    ,nvl(n.charge_dt, o.charge_dt) as charge_dt -- 收费日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.decrs_lmt_flg, o.decrs_lmt_flg) as decrs_lmt_flg -- 减额标志
    ,nvl(n.margin_recvbl_ratio, o.margin_recvbl_ratio) as margin_recvbl_ratio -- 保证金应收比例
    ,nvl(n.mtg_bus_flg, o.mtg_bus_flg) as mtg_bus_flg -- 货押业务标志
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.margin_actl_recv_ratio, o.margin_actl_recv_ratio) as margin_actl_recv_ratio -- 保证金实收比例
    ,nvl(n.fin_log_flg, o.fin_log_flg) as fin_log_flg -- 融资性保函标志
    ,nvl(n.open_type_cd, o.open_type_cd) as open_type_cd -- 开立类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.src_agt_id <> n.src_agt_id
                or o.log_bus_id <> n.log_bus_id
                or o.tran_descb <> n.tran_descb
                or o.log_effect_dt <> n.log_effect_dt
                or o.full_amt_pay_dt <> n.full_amt_pay_dt
                or o.indent_dt <> n.indent_dt
                or o.log_invalid_dt <> n.log_invalid_dt
                or o.cty_rg_cd <> n.cty_rg_cd
                or o.edit_id <> n.edit_id
                or o.log_open_type_cd <> n.log_open_type_cd
                or o.cont_id <> n.cont_id
                or o.cancel_rs_cd <> n.cancel_rs_cd
                or o.decrs_lmt_amt <> n.decrs_lmt_amt
                or o.decrs_lmt_curr_cd <> n.decrs_lmt_curr_cd
                or o.decrs_lmt_dt <> n.decrs_lmt_dt
                or o.bal_curr_cd <> n.bal_curr_cd
                or o.bal <> n.bal
                or o.acpt_flg <> n.acpt_flg
                or o.acpt_ratio <> n.acpt_ratio
                or o.open_dt <> n.open_dt
                or o.acpt_way_cd <> n.acpt_way_cd
                or o.log_kind_cd <> n.log_kind_cd
                or o.charge_dt <> n.charge_dt
                or o.tran_org_id <> n.tran_org_id
                or o.belong_org_id <> n.belong_org_id
                or o.decrs_lmt_flg <> n.decrs_lmt_flg
                or o.margin_recvbl_ratio <> n.margin_recvbl_ratio
                or o.mtg_bus_flg <> n.mtg_bus_flg
                or o.dubil_id <> n.dubil_id
                or o.margin_actl_recv_ratio <> n.margin_actl_recv_ratio
                or o.fin_log_flg <> n.fin_log_flg
                or o.open_type_cd <> n.open_type_cd
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_log_info_isbsf1_tm n
    full join ${iml_schema}.agt_log_info_isbsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_log_info truncate partition for ('isbsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_log_info exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_log_info_isbsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_log_info drop subpartition p_isbsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_log_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_log_info_isbsf1_tm purge;
drop table ${iml_schema}.agt_log_info_isbsf1_ex purge;
drop table ${iml_schema}.agt_log_info_isbsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_log_info', partname => 'p_isbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);