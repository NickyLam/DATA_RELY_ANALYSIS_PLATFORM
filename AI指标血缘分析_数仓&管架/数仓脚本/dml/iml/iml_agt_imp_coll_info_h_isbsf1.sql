/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_imp_coll_info_h_isbsf1
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
alter table ${iml_schema}.agt_imp_coll_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_imp_coll_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_coll_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_coll_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_imp_coll_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_coll_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_coll_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_bcd-1
insert into ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300049'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 交易流水号
    ,P1.OWNREF -- 交易编号
    ,P1.NAM -- 交易名称
    ,nvl(trim(P1.STAGOD),'-') -- 货物类型代码
    ,nvl(trim(P1.RELGODFLG),'N') -- 货物授权代码
    ,P1.RELGODDAT -- 货物到达日期
    ,P1.RCVDAT -- 收货日期
    ,P1.PREDAT -- 提示日期
    ,P1.SHPDAT -- 发船日期
    ,P1.CREDAT -- 创建日期
    ,P1.ADVDAT -- 通知日期
    ,iml.dateformat_min(P1.MATPERBEG) -- 生效日期
    ,P1.MATDAT -- 失效日期
    ,P1.CLSDAT -- 到期日期
    ,P1.MATPERCNT -- 生效天数
    ,nvl(trim(P1.MATPERTYP),'-') -- 日期类型代码
    ,P1.OPNDAT -- 开证日期
    ,nvl(trim(P1.DOCTYPCOD),'-') -- 代收类型代码
    ,P1.OWNUSR -- 业务经办柜员编号
    ,nvl(trim(P1.TRPDOCTYP),'-') -- 单据类型代码
    ,nvl(trim(P1.DOCSTA),'-') -- 单据状态代码
    ,P1.TRPDOCNUM -- 单据编号
    ,P1.TRADAT -- 发单日期
    ,nvl(trim(P1.TRAMOD),'-') -- 发单方式代码
    ,P1.SHPFRO -- 发货地点
    ,P1.SHPTO -- 到货地点
    ,nvl(trim(P1.CHATO),'-') -- 付款方向代码
    ,nvl(trim(P1.OTHINS),'-') -- 延期付款类型代码
    ,P1.STACTY -- 国家编号
    ,P1.ACCDAT -- 承兑日期
    ,decode(trim(P1.DFTGARFLG),'X','1','','0',P1.DFTGARFLG) -- 银行担保标志
    ,P1.EXPDAT -- 运输担保到期日期
    ,nvl(trim(P1.RELTYP),'-') -- 提货类型代码
    ,P1.AGTDAT -- 提货日期
    ,decode(trim(P1.RTODREFLG),'X','1','','0',P1.RTODREFLG) -- 放货标志
    ,decode(trim(P1.MATTXTFLG),'X','1','','0',P1.MATTXTFLG) -- 混合付款标志
    ,decode(trim(P1.FOCFLG),'X','1','','0',P1.FOCFLG) -- 免付款交单标志
    ,decode(trim(P1.RESFLG),'X','1','','0',P1.RESFLG) -- 正常交易标志
    ,P1.WAICOLCOD -- 代收行费用遭拒付时放弃标识
    ,P1.WAIRMTCOD -- 我方费用遭拒付时放弃标识
    ,decode(trim(P1.ORIDRE),'X','1','','0',P1.ORIDRE) -- 发送面函标志
    ,decode(trim(P1.NRAFLG),'Y','1','N','0','','-',P1.NRAFLG) -- NRA收款标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.QSQDBH END -- 清算渠道代码
    ,nvl(trim(P1.PROINS),'-') -- 拒付标志代码
    ,nvl(trim(P2.BRANCH),' ') -- 所属机构编号
    ,nvl(trim(P2.BCHKEY),' ') -- 经办机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_bcd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_bcd p1
    left join ${iol_schema}.isbs_bch p2 on  P1.BRANCHINR = P2.INR
    AND p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.QSQDBH = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_BCD'
        AND R2.SRC_FIELD_EN_NAME= 'QSQDBH'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IMP_COLL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')

;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_coll_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.cargo_type_cd, o.cargo_type_cd) as cargo_type_cd -- 货物类型代码
    ,nvl(n.cargo_auth_cd, o.cargo_auth_cd) as cargo_auth_cd -- 货物授权代码
    ,nvl(n.cargo_arrive_dt, o.cargo_arrive_dt) as cargo_arrive_dt -- 货物到达日期
    ,nvl(n.revid_cargo_dt, o.revid_cargo_dt) as revid_cargo_dt -- 收货日期
    ,nvl(n.sugst_dt, o.sugst_dt) as sugst_dt -- 提示日期
    ,nvl(n.ship_send_out_dt, o.ship_send_out_dt) as ship_send_out_dt -- 发船日期
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.advise_dt, o.advise_dt) as advise_dt -- 通知日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.effect_days, o.effect_days) as effect_days -- 生效天数
    ,nvl(n.dt_type_cd, o.dt_type_cd) as dt_type_cd -- 日期类型代码
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 开证日期
    ,nvl(n.coll_type_cd, o.coll_type_cd) as coll_type_cd -- 代收类型代码
    ,nvl(n.bus_oper_teller_id, o.bus_oper_teller_id) as bus_oper_teller_id -- 业务经办柜员编号
    ,nvl(n.doc_type_cd, o.doc_type_cd) as doc_type_cd -- 单据类型代码
    ,nvl(n.doc_status_cd, o.doc_status_cd) as doc_status_cd -- 单据状态代码
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 单据编号
    ,nvl(n.doc_send_out_dt, o.doc_send_out_dt) as doc_send_out_dt -- 发单日期
    ,nvl(n.doc_send_out_way_cd, o.doc_send_out_way_cd) as doc_send_out_way_cd -- 发单方式代码
    ,nvl(n.dispatch_site, o.dispatch_site) as dispatch_site -- 发货地点
    ,nvl(n.cargo_arrive_site, o.cargo_arrive_site) as cargo_arrive_site -- 到货地点
    ,nvl(n.pay_dir_cd, o.pay_dir_cd) as pay_dir_cd -- 付款方向代码
    ,nvl(n.delay_pay_type_cd, o.delay_pay_type_cd) as delay_pay_type_cd -- 延期付款类型代码
    ,nvl(n.cty_id, o.cty_id) as cty_id -- 国家编号
    ,nvl(n.acpt_dt, o.acpt_dt) as acpt_dt -- 承兑日期
    ,nvl(n.bank_guar_flg, o.bank_guar_flg) as bank_guar_flg -- 银行担保标志
    ,nvl(n.traff_guar_exp_dt, o.traff_guar_exp_dt) as traff_guar_exp_dt -- 运输担保到期日期
    ,nvl(n.pick_goods_type_cd, o.pick_goods_type_cd) as pick_goods_type_cd -- 提货类型代码
    ,nvl(n.pick_goods_dt, o.pick_goods_dt) as pick_goods_dt -- 提货日期
    ,nvl(n.goods_flg, o.goods_flg) as goods_flg -- 放货标志
    ,nvl(n.blend_pay_flg, o.blend_pay_flg) as blend_pay_flg -- 混合付款标志
    ,nvl(n.free_pay_present_flg, o.free_pay_present_flg) as free_pay_present_flg -- 免付款交单标志
    ,nvl(n.nomal_tran_flg, o.nomal_tran_flg) as nomal_tran_flg -- 正常交易标志
    ,nvl(n.coll_bk_fee_refuse_pay_give_up_idf, o.coll_bk_fee_refuse_pay_give_up_idf) as coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,nvl(n.ghb_fee_refuse_pay_give_up_idf, o.ghb_fee_refuse_pay_give_up_idf) as ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,nvl(n.send_face_letr_flg, o.send_face_letr_flg) as send_face_letr_flg -- 发送面函标志
    ,nvl(n.nra_recvbl_flg, o.nra_recvbl_flg) as nra_recvbl_flg -- NRA收款标志
    ,nvl(n.clear_chn_cd, o.clear_chn_cd) as clear_chn_cd -- 清算渠道代码
    ,nvl(n.refuse_pay_flg_cd, o.refuse_pay_flg_cd) as refuse_pay_flg_cd -- 拒付标志代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_imp_coll_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.tran_id <> n.tran_id
        or o.tran_name <> n.tran_name
        or o.cargo_type_cd <> n.cargo_type_cd
        or o.cargo_auth_cd <> n.cargo_auth_cd
        or o.cargo_arrive_dt <> n.cargo_arrive_dt
        or o.revid_cargo_dt <> n.revid_cargo_dt
        or o.sugst_dt <> n.sugst_dt
        or o.ship_send_out_dt <> n.ship_send_out_dt
        or o.create_date <> n.create_date
        or o.advise_dt <> n.advise_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.exp_dt <> n.exp_dt
        or o.effect_days <> n.effect_days
        or o.dt_type_cd <> n.dt_type_cd
        or o.issue_dt <> n.issue_dt
        or o.coll_type_cd <> n.coll_type_cd
        or o.bus_oper_teller_id <> n.bus_oper_teller_id
        or o.doc_type_cd <> n.doc_type_cd
        or o.doc_status_cd <> n.doc_status_cd
        or o.doc_id <> n.doc_id
        or o.doc_send_out_dt <> n.doc_send_out_dt
        or o.doc_send_out_way_cd <> n.doc_send_out_way_cd
        or o.dispatch_site <> n.dispatch_site
        or o.cargo_arrive_site <> n.cargo_arrive_site
        or o.pay_dir_cd <> n.pay_dir_cd
        or o.delay_pay_type_cd <> n.delay_pay_type_cd
        or o.cty_id <> n.cty_id
        or o.acpt_dt <> n.acpt_dt
        or o.bank_guar_flg <> n.bank_guar_flg
        or o.traff_guar_exp_dt <> n.traff_guar_exp_dt
        or o.pick_goods_type_cd <> n.pick_goods_type_cd
        or o.pick_goods_dt <> n.pick_goods_dt
        or o.goods_flg <> n.goods_flg
        or o.blend_pay_flg <> n.blend_pay_flg
        or o.free_pay_present_flg <> n.free_pay_present_flg
        or o.nomal_tran_flg <> n.nomal_tran_flg
        or o.coll_bk_fee_refuse_pay_give_up_idf <> n.coll_bk_fee_refuse_pay_give_up_idf
        or o.ghb_fee_refuse_pay_give_up_idf <> n.ghb_fee_refuse_pay_give_up_idf
        or o.send_face_letr_flg <> n.send_face_letr_flg
        or o.nra_recvbl_flg <> n.nra_recvbl_flg
        or o.clear_chn_cd <> n.clear_chn_cd
        or o.refuse_pay_flg_cd <> n.refuse_pay_flg_cd
        or o.belong_org_id <> n.belong_org_id
        or o.oper_org_id <> n.oper_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_coll_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_id -- 交易编号
    ,tran_name -- 交易名称
    ,cargo_type_cd -- 货物类型代码
    ,cargo_auth_cd -- 货物授权代码
    ,cargo_arrive_dt -- 货物到达日期
    ,revid_cargo_dt -- 收货日期
    ,sugst_dt -- 提示日期
    ,ship_send_out_dt -- 发船日期
    ,create_date -- 创建日期
    ,advise_dt -- 通知日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,exp_dt -- 到期日期
    ,effect_days -- 生效天数
    ,dt_type_cd -- 日期类型代码
    ,issue_dt -- 开证日期
    ,coll_type_cd -- 代收类型代码
    ,bus_oper_teller_id -- 业务经办柜员编号
    ,doc_type_cd -- 单据类型代码
    ,doc_status_cd -- 单据状态代码
    ,doc_id -- 单据编号
    ,doc_send_out_dt -- 发单日期
    ,doc_send_out_way_cd -- 发单方式代码
    ,dispatch_site -- 发货地点
    ,cargo_arrive_site -- 到货地点
    ,pay_dir_cd -- 付款方向代码
    ,delay_pay_type_cd -- 延期付款类型代码
    ,cty_id -- 国家编号
    ,acpt_dt -- 承兑日期
    ,bank_guar_flg -- 银行担保标志
    ,traff_guar_exp_dt -- 运输担保到期日期
    ,pick_goods_type_cd -- 提货类型代码
    ,pick_goods_dt -- 提货日期
    ,goods_flg -- 放货标志
    ,blend_pay_flg -- 混合付款标志
    ,free_pay_present_flg -- 免付款交单标志
    ,nomal_tran_flg -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg -- 发送面函标志
    ,nra_recvbl_flg -- NRA收款标志
    ,clear_chn_cd -- 清算渠道代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,belong_org_id -- 所属机构编号
    ,oper_org_id -- 经办机构编号
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
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_id -- 交易编号
    ,o.tran_name -- 交易名称
    ,o.cargo_type_cd -- 货物类型代码
    ,o.cargo_auth_cd -- 货物授权代码
    ,o.cargo_arrive_dt -- 货物到达日期
    ,o.revid_cargo_dt -- 收货日期
    ,o.sugst_dt -- 提示日期
    ,o.ship_send_out_dt -- 发船日期
    ,o.create_date -- 创建日期
    ,o.advise_dt -- 通知日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.exp_dt -- 到期日期
    ,o.effect_days -- 生效天数
    ,o.dt_type_cd -- 日期类型代码
    ,o.issue_dt -- 开证日期
    ,o.coll_type_cd -- 代收类型代码
    ,o.bus_oper_teller_id -- 业务经办柜员编号
    ,o.doc_type_cd -- 单据类型代码
    ,o.doc_status_cd -- 单据状态代码
    ,o.doc_id -- 单据编号
    ,o.doc_send_out_dt -- 发单日期
    ,o.doc_send_out_way_cd -- 发单方式代码
    ,o.dispatch_site -- 发货地点
    ,o.cargo_arrive_site -- 到货地点
    ,o.pay_dir_cd -- 付款方向代码
    ,o.delay_pay_type_cd -- 延期付款类型代码
    ,o.cty_id -- 国家编号
    ,o.acpt_dt -- 承兑日期
    ,o.bank_guar_flg -- 银行担保标志
    ,o.traff_guar_exp_dt -- 运输担保到期日期
    ,o.pick_goods_type_cd -- 提货类型代码
    ,o.pick_goods_dt -- 提货日期
    ,o.goods_flg -- 放货标志
    ,o.blend_pay_flg -- 混合付款标志
    ,o.free_pay_present_flg -- 免付款交单标志
    ,o.nomal_tran_flg -- 正常交易标志
    ,o.coll_bk_fee_refuse_pay_give_up_idf -- 代收行费用遭拒付时放弃标识
    ,o.ghb_fee_refuse_pay_give_up_idf -- 我方费用遭拒付时放弃标识
    ,o.send_face_letr_flg -- 发送面函标志
    ,o.nra_recvbl_flg -- NRA收款标志
    ,o.clear_chn_cd -- 清算渠道代码
    ,o.refuse_pay_flg_cd -- 拒付标志代码
    ,o.belong_org_id -- 所属机构编号
    ,o.oper_org_id -- 经办机构编号
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
from ${iml_schema}.agt_imp_coll_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_imp_coll_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_imp_coll_info_h;
--alter table ${iml_schema}.agt_imp_coll_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_imp_coll_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_imp_coll_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_imp_coll_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_imp_coll_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_imp_coll_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_imp_coll_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_imp_coll_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_imp_coll_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_imp_coll_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
