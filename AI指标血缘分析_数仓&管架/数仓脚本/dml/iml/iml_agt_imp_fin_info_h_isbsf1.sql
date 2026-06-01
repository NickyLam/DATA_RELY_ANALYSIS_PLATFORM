/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_imp_fin_info_h_isbsf1
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
alter table ${iml_schema}.agt_imp_fin_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_imp_fin_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_fin_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_fin_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_imp_fin_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_fin_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_fin_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_trd-1
insert into ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 内部编号
    ,P1.FINCOD -- 借据编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.IRTCOD END -- 利率类型代码
    ,P1.INTRAT -- 基准利率
    ,P1.ACTYLD -- 实际利率
    ,P1.ACTRAT -- 执行利率
    ,P1.ISSDAT -- 起息日期
    ,P1.LSTINTDAT -- 上一利息结算日期
    ,DECODE(P1.DELFLG,'Y','1','0') -- 逾期标志
    ,P1.GRARAT -- 逾期利率
    ,P1.OVDDAT -- 逾期日期
    ,P1.SPDDAT -- 逾期起始日期
    ,P1.PNTTYP -- 关联对象名称
    ,P1.PNTINR -- 关联对象编号
    ,P1.PNTREF -- 父业务编号
    ,P1.PNTNAM -- 父业务描述
    ,P1.CREDAT -- 交易经办日期
    ,P1.CLSDAT -- 交易完成日期
    ,P1.NAM -- 交易描述
    ,P1.OWNREF -- 交易编号
    ,P1.OWNUSR -- 经办柜员编号
    ,P2.BRANCH -- 经办机构编号
    ,P3.BRANCH -- 所属机构编号
    ,nvl(trim(P1.FINTYP),'-') -- 融资类型代码
    ,P1.PCTFIN -- 融资金额比例
    ,nvl(trim(P1.STACTY),'XXX') -- 融资涉及国家地区代码
    ,nvl(trim(P1.RESTCUR),'-') -- 融资币种代码
    ,nvl(trim(P1.OVDFLG),'-') -- 融资状态代码
    ,P1.TENDAY -- 融资天数
    ,P1.MATDAT -- 融资到期日期
    ,P1.OPNDAT -- 融资登记日期
    ,nvl(trim(P1.DFTYPE),'-') -- 进口融资代付类型代码
    ,P1.DFRATE -- 代付正常利率
    ,P1.STTTENDAT -- 代付起息日期
    ,nvl(trim(P1.FEETYP),'-') -- 收支类型代码
    ,P1.FEEAMT -- 收支金额
    ,nvl(trim(P1.STAGOD),'-') -- 制品类型代码
    ,DECODE(P1.GUAFLG,'1','1','0','0') -- 货押标志
    ,nvl(trim(P1.SUBTYP),'-') -- 代付业务品种代码	
    ,P1.DFINT	-- 预估代付总利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_trd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_trd p1
    left join ${iol_schema}.isbs_bch p2 on P1.BCHKEYINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BRANCHINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
and p3.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.ref_pub_cd_map R1
on P1.IRTCOD=R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD='ISBS'
AND R1.SRC_TAB_EN_NAME='ISBS_TRD'
AND R1.SRC_FIELD_EN_NAME='IRTCOD'
AND R1.TARGET_TAB_EN_NAME='AGT_IMP_FIN_INFO_H'
AND R1.TARGET_TAB_FIELD_EN_NAME='INT_RAT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,intnal_id
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
        into ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_fin_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intnal_id, o.intnal_id) as intnal_id -- 内部编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.actl_int_rat, o.actl_int_rat) as actl_int_rat -- 实际利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.last_int_stl_dt, o.last_int_stl_dt) as last_int_stl_dt -- 上一利息结算日期
    ,nvl(n.ovdue_flg, o.ovdue_flg) as ovdue_flg -- 逾期标志
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.ovdue_begin_dt, o.ovdue_begin_dt) as ovdue_begin_dt -- 逾期起始日期
    ,nvl(n.rela_obj_name, o.rela_obj_name) as rela_obj_name -- 关联对象名称
    ,nvl(n.rela_obj_id, o.rela_obj_id) as rela_obj_id -- 关联对象编号
    ,nvl(n.parent_bus_id, o.parent_bus_id) as parent_bus_id -- 父业务编号
    ,nvl(n.parent_bus_descb, o.parent_bus_descb) as parent_bus_descb -- 父业务描述
    ,nvl(n.tran_oper_dt, o.tran_oper_dt) as tran_oper_dt -- 交易经办日期
    ,nvl(n.tran_cmplt_dt, o.tran_cmplt_dt) as tran_cmplt_dt -- 交易完成日期
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.fin_type_cd, o.fin_type_cd) as fin_type_cd -- 融资类型代码
    ,nvl(n.fin_amt_ratio, o.fin_amt_ratio) as fin_amt_ratio -- 融资金额比例
    ,nvl(n.fin_invo_cty_rg_cd, o.fin_invo_cty_rg_cd) as fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,nvl(n.fin_curr_cd, o.fin_curr_cd) as fin_curr_cd -- 融资币种代码
    ,nvl(n.fin_status_cd, o.fin_status_cd) as fin_status_cd -- 融资状态代码
    ,nvl(n.fin_days, o.fin_days) as fin_days -- 融资天数
    ,nvl(n.fin_exp_dt, o.fin_exp_dt) as fin_exp_dt -- 融资到期日期
    ,nvl(n.fin_rgst_dt, o.fin_rgst_dt) as fin_rgst_dt -- 融资登记日期
    ,nvl(n.imp_fin_payfan_type_cd, o.imp_fin_payfan_type_cd) as imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,nvl(n.payfan_nomal_int_rat, o.payfan_nomal_int_rat) as payfan_nomal_int_rat -- 代付正常利率
    ,nvl(n.payfan_value_dt, o.payfan_value_dt) as payfan_value_dt -- 代付起息日期
    ,nvl(n.bal_pay_type_cd, o.bal_pay_type_cd) as bal_pay_type_cd -- 收支类型代码
    ,nvl(n.bal_pay_amt, o.bal_pay_amt) as bal_pay_amt -- 收支金额
    ,nvl(n.manuf_prd_type_cd, o.manuf_prd_type_cd) as manuf_prd_type_cd -- 制品类型代码
    ,nvl(n.mtg_flg, o.mtg_flg) as mtg_flg -- 货押标志
    ,nvl(n.payfan_bus_breed_cd, o.payfan_bus_breed_cd) as payfan_bus_breed_cd -- 货押标志
    ,nvl(n.expect_payfan_int, o.expect_payfan_int) as expect_payfan_int -- 货押标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_imp_fin_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.intnal_id = n.intnal_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.intnal_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.intnal_id is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.actl_int_rat <> n.actl_int_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.value_dt <> n.value_dt
        or o.last_int_stl_dt <> n.last_int_stl_dt
        or o.ovdue_flg <> n.ovdue_flg
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.ovdue_dt <> n.ovdue_dt
        or o.ovdue_begin_dt <> n.ovdue_begin_dt
        or o.rela_obj_name <> n.rela_obj_name
        or o.rela_obj_id <> n.rela_obj_id
        or o.parent_bus_id <> n.parent_bus_id
        or o.parent_bus_descb <> n.parent_bus_descb
        or o.tran_oper_dt <> n.tran_oper_dt
        or o.tran_cmplt_dt <> n.tran_cmplt_dt
        or o.tran_descb <> n.tran_descb
        or o.tran_id <> n.tran_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.belong_org_id <> n.belong_org_id
        or o.fin_type_cd <> n.fin_type_cd
        or o.fin_amt_ratio <> n.fin_amt_ratio
        or o.fin_invo_cty_rg_cd <> n.fin_invo_cty_rg_cd
        or o.fin_curr_cd <> n.fin_curr_cd
        or o.fin_status_cd <> n.fin_status_cd
        or o.fin_days <> n.fin_days
        or o.fin_exp_dt <> n.fin_exp_dt
        or o.fin_rgst_dt <> n.fin_rgst_dt
        or o.imp_fin_payfan_type_cd <> n.imp_fin_payfan_type_cd
        or o.payfan_nomal_int_rat <> n.payfan_nomal_int_rat
        or o.payfan_value_dt <> n.payfan_value_dt
        or o.bal_pay_type_cd <> n.bal_pay_type_cd
        or o.bal_pay_amt <> n.bal_pay_amt
        or o.manuf_prd_type_cd <> n.manuf_prd_type_cd
        or o.mtg_flg <> n.mtg_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_fin_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,dubil_id -- 借据编号
    ,int_rat_type_cd -- 利率类型代码
    ,base_rat -- 基准利率
    ,actl_int_rat -- 实际利率
    ,exec_int_rat -- 执行利率
    ,value_dt -- 起息日期
    ,last_int_stl_dt -- 上一利息结算日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_dt -- 逾期日期
    ,ovdue_begin_dt -- 逾期起始日期
    ,rela_obj_name -- 关联对象名称
    ,rela_obj_id -- 关联对象编号
    ,parent_bus_id -- 父业务编号
    ,parent_bus_descb -- 父业务描述
    ,tran_oper_dt -- 交易经办日期
    ,tran_cmplt_dt -- 交易完成日期
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,belong_org_id -- 所属机构编号
    ,fin_type_cd -- 融资类型代码
    ,fin_amt_ratio -- 融资金额比例
    ,fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,fin_curr_cd -- 融资币种代码
    ,fin_status_cd -- 融资状态代码
    ,fin_days -- 融资天数
    ,fin_exp_dt -- 融资到期日期
    ,fin_rgst_dt -- 融资登记日期
    ,imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,payfan_nomal_int_rat -- 代付正常利率
    ,payfan_value_dt -- 代付起息日期
    ,bal_pay_type_cd -- 收支类型代码
    ,bal_pay_amt -- 收支金额
    ,manuf_prd_type_cd -- 制品类型代码
    ,mtg_flg -- 货押标志
    ,payfan_bus_breed_cd -- 代付业务品种代码	
    ,expect_payfan_int	-- 预估代付总利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.intnal_id -- 内部编号
    ,o.dubil_id -- 借据编号
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.base_rat -- 基准利率
    ,o.actl_int_rat -- 实际利率
    ,o.exec_int_rat -- 执行利率
    ,o.value_dt -- 起息日期
    ,o.last_int_stl_dt -- 上一利息结算日期
    ,o.ovdue_flg -- 逾期标志
    ,o.ovdue_int_rat -- 逾期利率
    ,o.ovdue_dt -- 逾期日期
    ,o.ovdue_begin_dt -- 逾期起始日期
    ,o.rela_obj_name -- 关联对象名称
    ,o.rela_obj_id -- 关联对象编号
    ,o.parent_bus_id -- 父业务编号
    ,o.parent_bus_descb -- 父业务描述
    ,o.tran_oper_dt -- 交易经办日期
    ,o.tran_cmplt_dt -- 交易完成日期
    ,o.tran_descb -- 交易描述
    ,o.tran_id -- 交易编号
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_org_id -- 经办机构编号
    ,o.belong_org_id -- 所属机构编号
    ,o.fin_type_cd -- 融资类型代码
    ,o.fin_amt_ratio -- 融资金额比例
    ,o.fin_invo_cty_rg_cd -- 融资涉及国家地区代码
    ,o.fin_curr_cd -- 融资币种代码
    ,o.fin_status_cd -- 融资状态代码
    ,o.fin_days -- 融资天数
    ,o.fin_exp_dt -- 融资到期日期
    ,o.fin_rgst_dt -- 融资登记日期
    ,o.imp_fin_payfan_type_cd -- 进口融资代付类型代码
    ,o.payfan_nomal_int_rat -- 代付正常利率
    ,o.payfan_value_dt -- 代付起息日期
    ,o.bal_pay_type_cd -- 收支类型代码
    ,o.bal_pay_amt -- 收支金额
    ,o.manuf_prd_type_cd -- 制品类型代码
    ,o.mtg_flg -- 货押标志
    ,o.payfan_bus_breed_cd -- 代付业务品种代码	
    ,o.expect_payfan_int	-- 预估代付总利息
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
from ${iml_schema}.agt_imp_fin_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_imp_fin_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.intnal_id = n.intnal_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.intnal_id = d.intnal_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_imp_fin_info_h;
--alter table ${iml_schema}.agt_imp_fin_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_imp_fin_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_imp_fin_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_imp_fin_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_imp_fin_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_imp_fin_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_imp_fin_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_imp_fin_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_imp_fin_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_imp_fin_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
