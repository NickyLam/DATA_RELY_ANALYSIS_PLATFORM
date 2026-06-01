/*
Purpose:    共性加工层-押品信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_col_info
CreateDate: 20190808
Logs:
            20191206 翟若平 t1表过滤条件改为SUBSTR(T1.COL_TYPE_ID,1,2) IN ('DY','ZY', 'BZ')
            20200327 翟若平 调整字段[机构编号、我行确认价值、我行初次评估价值]的取数口径
            20200724 周沁晖 增加字段【主押品标志、权利人客户编号、入库记账机构编号、入库记账价值、入库记账币种代码、到期日期、存单凭证编号、存单生效日期、存单到期日期、存单存期、存单存期天数、存单利率、存单币种代码、存单可用金额、存单账户余额、房产月物业费、房产建筑面积】
            20200925 周沁晖 增加字段【我行存单标志】
            20201127 周沁晖 调整t6表为拉链表过滤条件
            20210312 周沁晖 新增字段【权利人客户编号】、【所有权人名称】、【评估人】、【评估到期日期】、【押品价值】、【已抵押价值】、【权利登记日期】、【核保日期】、【核保人姓名1】、【核保人姓名2】、
                                    【操作机构编号】、【登记机构名称】、【实物收取日期】、【抵质押率】、【最高抵押率】、【押品评估币种代码】、【押品评估价值】、【押品存放地址】、【押品权属类型代码】、
                                    【评估机构名称】、【评估机构证件号码】、【评估机构登记机关名称】、【权属人名称】、【出质人证件类型代码】、【出质人证件号码】、【权证类型代码】、
                                    【权证登记号码二】、【权属登记机关】、【权证登记号码】、【权证名称】、【租赁标志】、【担保品承租人】、【租赁起始日期】、【租赁到期日期】、【租赁情况描述】、【登记到期日期】、
                                    【登记期限】、【登记人编号】、【入库日期】、【备注】 共 40 个字段
                            调整字段【估值日期】
            20210511 陈伟峰 调整gcust_flg-待保管标志字段默认值,"0"->"-"
                            调整权利人客户编号逻辑，加入去空判断处理，nvl(t12.ecifcustcode,t12.voucherno)->nvl(trim(t12.ecifcustcode),t12.voucherno)
                            调整押品评估价值逻辑，加入非0判断处理，t3.ext_estim_val->decode(t3.ext_estim_val,0,'')
            20210519 陈伟峰 调整估值日期取值口径，ext_estim_exp_dt-(外部评估到期日期)->ext_formal_estim_dt（外部正式估值日期）
            20210527 何桐金 调整已抵押价值逻辑，将0转换为''
            20210624 陈伟峰 调整估值日期取值口径，ext_formal_estim_dt（外部正式估值日期）->estim_dt（估值日期）
            20210802 陈伟峰 调整【已抵押价值】加工逻辑，当担保金额为0时取0，当担保金额大于押品价值或者我行认定价值时，取押品价值或者我行认定价值，否则取担保金额
                            调整【押品价值】加工逻辑
                            调整【押品评估价值】加工逻辑，正式评估报告，优先取正式估值；没有正式评估报告，优先取预估值
            20211028 何桐金 增加字段【优先受偿权数额】
            20231023 徐子豪 新增字段【我行第一顺位标志】,押品关联逻辑优化
            20240422 饶雅   新增字段【抵质押品标志、押品修改标志】
            20240422 谢宁   新增字段【竣工标志】
            20250917 陈伟峰 调整取数来源，改为信贷系统，优化各字段取数规则

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_col_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_col_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_col_info_ex purge;
drop table ${icl_schema}.tmp_cmm_col_info_01 purge;
drop table ${icl_schema}.tmp_cmm_col_info_02 purge;

whenever sqlerror exit sql.sqlcode;



create table ${icl_schema}.tmp_cmm_col_info_01
nologging
compress ${option_switch} for query high
as
select t1.asset_id
        ,t2.insto_org_id  --押品记账机构
        ,case when t1.col_type_id='90010020020' then t3.perprice*t3.amount  --非标仓单(“账面单价”乘以“账面数量”)   --90010020020 非标准仓单
                when t1.col_type_id='90010030010' then t4.perprice*t4.amount  --提单(“账面单价”乘以“账面数量”)   --90010030010 提单
                when t1.col_type_id in ('60030010010','60030010020','60030010030','60030070010','60030080010','60030020010','60030050010','60030060010') then t5.fac_val_amt  --债券(票面金额)
                --60030010010 储蓄式国债、60030010020 记账式国债、60030010030 其他国债、60030070010 非金融企业债、60030080010 其他债券、60030020010 地方政府债、60030050010 政策性银行发行的金融债券、60030060010 商业性金融债
                when t1.col_type_id in ('60040020010','60040010010') then t6.fac_val_amt --商业承兑汇票(票面金额)  --60040020010 纸质商业承兑汇票\60040010010 纸质银行承兑汇票
  --              when t1.col_type_id in ('60030030010','60040030010','60040030020','60040030030','60040040010') then t7.fac_val_amt --央行票据/银行本票/银行支票/银行汇票(票面金额)
                --60030030010 人民银行发行的票据、60040030010 银行本票、60040030020 银行支票、60040030030 银行汇票、60040040010 其他票据
                when t1.col_type_id ='60080020010' then t8.poolmoney --票据池(票面金额汇总)  --60080020010 资产池
                --其他的都取内评或外评价值”中非零的最小值。（如果两者都为0，则传我行认定价值。）
                when t2.estim_way_cd='01' and (t2.ext_estim_val=0  or t2.ext_pre_estim_val=0) then t2.hxb_cfm_val
                when t2.estim_way_cd='02' and t2.intnal_estim_val=0 then t2.hxb_cfm_val
                when t2.estim_way_cd='02' and t2.intnal_estim_val<>0 then t2.intnal_estim_val
                when t2.estim_way_cd='03' and t2.ext_estim_val=0 and t2.ext_pre_estim_val=0 and t2.intnal_estim_val=0 then t2.hxb_cfm_val
                when t2.estim_way_cd='03' then least(t2.intnal_estim_val,t2.ext_pre_estim_val,t2.ext_estim_val)  --取三者最小
                else 0 end amt
               --评估方式 01-外部评估、02-内部评估、03-外部和内部评估
   from ${iml_schema}.ast_col_basic_info t1
   left join ${iml_schema}.ast_col_val_info_h t2
      on t1.asset_id = t2.asset_id
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd ='icmsf1'
   left join ${iol_schema}.icms_clr_asset_other_fwarereceipt t3  --非标仓单
     on t1.asset_id=t3.clrid
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.icms_clr_asset_other_billofload t4  --提单
      on t1.asset_id=t4.clrid
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.ast_col_bond_info t5 --债券
      on t1.asset_id=t5.col_id
     and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t5.end_dt > to_date('${batch_date}','yyyymmdd')
    and t5.job_cd ='icmsf1'
   left join ${iml_schema}.ast_col_accpt_bil_info_h t6  --商业承兑汇票
      on t1.asset_id=t6.asset_id
    and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t6.end_dt > to_date('${batch_date}','yyyymmdd')
    and t6.job_cd ='icmsf1'
/*   left join ${iml_schema}.ast_col_bill_info_h t7  --央行票据/银行本票/银行支票/银行汇票
      on t1.asset_id=t7.asset_id
     and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t7.end_dt > to_date('${batch_date}','yyyymmdd')
    and t7.job_cd ='icmsf1' */
   left join ${iol_schema}.icms_clr_asset_finance_assetpool t8  --票据池
      on t1.asset_id=t8.clrid
     and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
     and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.id_mark <>'D'
    and t1.job_cd ='icmsf1'
;



create table ${icl_schema}.tmp_cmm_col_info_02
nologging
compress ${option_switch} for query high
as
select asset_id as clrid
        ,rent_flg as isrents
        ,tentry_name as hpaddr
        ,rent_exp_dt as hireedate
        ,rent_begin_dt as hiresdate
        ,rent_situ_comnt as hireremark
        ,rel_esat_wat_rgst_addr as address
        ,house_cmplt_flg as iscompleted
    from ${iml_schema}.ast_col_resd_build_info
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
  union
  select asset_id as clrid
        ,rent_flg as isrents
        ,tentry_name as hpaddr
        ,rent_exp_dt as hireedate
        ,rent_begin_dt as hiresdate
        ,rent_situ_comnt as hireremark
        ,rel_esat_wat_rgst_addr as address
        ,house_cmplt_flg as iscompleted
    from ${iml_schema}.ast_col_gare_info 
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
  union
  select asset_id as clrid
        ,rent_flg as isrents
        ,tentry_name as hpaddr
        ,rent_exp_dt as hireedate
        ,rent_begin_dt as hiresdate
        ,rent_situ_comnt as hireremark
        ,rel_esat_wat_rgst_addr as address
        ,house_cmplt_flg as iscompleted
    from ${iml_schema}.ast_col_comer_build_info
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
  union
  select asset_id as clrid
        ,rent_flg as isrents
        ,tentry_name as hpaddr
        ,rent_exp_dt as hireedate
        ,rent_begin_dt as hiresdate
        ,rent_situ_comnt as hireremark
        ,rel_esat_wat_rgst_addr as address
        ,house_cmplt_flg as iscompleted
    from ${iml_schema}.ast_col_indu_build_info
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
  union
  select clrid
        ,isrents
        ,hpaddr
        ,hireedate
        ,hiresdate
        ,hireremark
        ,address
        ,iscompleted
    from ${iol_schema}.icms_clr_asset_property_otherliving
   where start_dt <= to_date('${batch_date}','yyyymmdd')
     and end_dt > to_date('${batch_date}','yyyymmdd')
  union
  select clrid
        ,'' as isrents
        ,'' as hpaddr
        ,to_date('00010101','yyyymmdd') as hireedate
        ,to_date('00010101','yyyymmdd') as hiresdate
        ,'' as hireremark
        ,address
        ,'' as iscompleted
    from ${iol_schema}.icms_clr_asset_receivable_toll
   where start_dt <= to_date('${batch_date}','yyyymmdd')
     and end_dt > to_date('${batch_date}','yyyymmdd')
  union
  select col_id as clrid
        ,'' as isrents
        ,'' as hpaddr
        ,to_date('00010101','yyyymmdd') as hireedate
        ,to_date('00010101','yyyymmdd') as hiresdate
        ,'' as hireremark
        ,land_dtl_addr as address
        ,'' as iscompleted
    from ${iml_schema}.ast_col_land_prop_info
   where start_dt <= to_date('${batch_date}','yyyymmdd')
      and end_dt <= to_date('${batch_date}','yyyymmdd')
      and job_cd ='icmsf1'
  union
  select asset_id as clrid
        ,'' as isrents
        ,'' as hpaddr
        ,to_date('00010101','yyyymmdd') as hireedate
        ,to_date('00010101','yyyymmdd') as hiresdate
        ,'' as hireremark
        ,phys_addr as address
        ,house_cmplt_flg as iscompleted
    from ${iml_schema}.ast_col_cnstring_proj_info
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
  union
  select asset_id as clrid
        ,'' as isrents
        ,'' as hpaddr
        ,to_date('00010101','yyyymmdd') as hireedate
        ,to_date('00010101','yyyymmdd') as hiresdate
        ,'' as hireremark
        ,supv_corp_name as address
        ,'' as iscompleted
    from ${iml_schema}.ast_col_inv_info
   where create_dt <= to_date('${batch_date}','yyyymmdd')
      and id_mark <> 'D'
and job_cd ='icmsf1'
;


-- 2.1 insert data to ex table
create table ${icl_schema}.cmm_col_info_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_col_info where 0=1;


whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_info_ex(
   etl_dt                              -- 数据日期
   ,lp_id                              -- 法人编号
   ,col_id                            -- 押品编号
   ,col_type_id                        -- 押品类型编号
   ,col_name                          -- 押品名称
   ,guar_way_cd                        -- 担保方式代码
   ,col_mgmt_id                        -- 押品管理员工编号
   ,org_id                            -- 机构编号
   ,prop_ps_id                         -- 权利人客户编号
   ,prop_ps_name                       -- 所有权人名称
   ,com_prot_flg                      -- 共同财产标志
   ,asset_obg_lot                      -- 资产权利人所占份额
   ,prior_comp_weight_qtty             -- 优先受偿权数额 
   ,guar_effect_way_cd                -- 担保生效方式代码
   ,trast_insure_flg                  -- 办理保险标志
   ,rgst_trast_status_cd              -- 登记办理状态代码
   ,insure_trast_status_cd            -- 保险办理状态代码
   ,insto_status_cd                    -- 入库状态代码
   ,rela_status_cd                    -- 关联状态代码
   ,espec_status_cd                    -- 特殊状态代码
   ,wt_md_cash_ability_cd              -- 权重法变现能力代码
   ,np_cash_ability_cd                -- 内评初级法变现能力代码
   ,obank_guar_flg            　　　　-- 他行担保标志
   ,gcust_flg                  　　　　-- 代保管标志
   ,fst_flg                            -- 我行第一顺位标志
   ,estim_curr_cd              　　　　-- 评估币种代码
   ,estim_val                  　　　　-- 评估价值
   ,estim_way_cd              　　　　-- 评估方式代码
   ,estim_dt                  　　　　-- 估值日期
   ,estim_ps_name                      -- 评估人名称
   ,estim_exp_dt                       -- 评估到期日期
   ,col_val                            -- 押品价值
   ,hxb_cfm_val                　　　　-- 我行确认价值
   ,mtged_val                          -- 已抵押价值
   ,right_rgst_dt                      -- 权利登记日期
   ,estim_idtfy_dt            　　　　-- 评估基准日
   ,hxb_pa_cfm_val            　　　　-- 我行初次评估价值
   ,save_hxb_flg              　　　　-- 保存我行标志
   ,setup_dt                  　　　　-- 建立日期
   ,check_guar_dt                      -- 核保日期
   ,ctfer_name_1                       -- 核保人姓名1
   ,ctfer_name_2                       -- 核保人姓名2
   ,modif_emply_id            　　　　-- 修改员工编号
   ,main_col_flg                       -- 主押品标志
   ,pmo_flg                            -- 抵质押品标志
   ,col_modif_flg                      -- 押品修改标志
   ,belong_cust_id                     -- 权利人客户编号
   ,oper_org_id                        -- 操作机构编号
   ,rgst_org_name                      -- 登记机构名称
   ,enty_coll_dt                       -- 实物收取日期
   ,pm_rat                             -- 抵质押率
   ,higt_mtg_rat                       -- 最高抵押率
   ,col_estim_curr_cd                  -- 押品评估币种代码
   ,col_estim_val                      -- 押品评估价值
   ,col_store_addr                     -- 押品存放地址
   ,col_belong_type_cd                 -- 押品权属类型代码
   ,estim_org_name                     -- 评估机构名称
   ,estim_org_orgnz_cd                 -- 评估机构证件号码
   ,estim_org_rgst_org_name            -- 评估机构登记机关名称
   ,pledgor_name                       -- 权属人名称
   ,pledgor_cert_type_cd               -- 出质人证件类型代码
   ,pledgor_cert_no                    -- 出质人证件号码
   ,belong_cert_type                   -- 权证类型代码
   ,belong_cert_no                     -- 权证登记号码二
   ,belong_rgst_org                    -- 权属登记机关
   ,wat_rgst_num                       -- 权证登记号码
   ,wat_name                           -- 权证名称
   ,cmplt_flg                          -- 竣工标志
   ,rent_flg                           -- 租赁标志
   ,guara_tentry                       -- 担保品承租人
   ,rent_begin_dt                      -- 租赁起始日期
   ,rent_exp_dt                        -- 租赁到期日期
   ,rent_situ_descb                    -- 租赁情况描述
   ,rgst_exp_dt                        -- 登记到期日期
   ,rgst_tenor                         -- 登记期限
   ,rgstrat_id                         -- 登记人编号
   ,insto_entry_org_id                 -- 入库记账机构编号
   ,insto_entry_val                    -- 入库记账价值
   ,insto_entry_curr_cd                -- 入库记账币种代码
   ,insto_dt                           -- 入库日期
   ,exp_dt                             -- 到期日期
   ,dep_rcpt_vouch_id                  -- 存单凭证编号
   ,hxb_dep_rcpt_flg                   -- 我行存单标志
   ,dep_rcpt_effect_dt                 -- 存单生效日期
   ,dep_rcpt_exp_dt                    -- 存单到期日期
   ,dep_rcpt_term                      -- 存单存期
   ,dep_rcpt_term_days                 -- 存单存期天数
   ,dep_rcpt_int_rat                   -- 存单利率
   ,dep_rcpt_curr_cd                   -- 存单币种代码
   ,dep_rcpt_aval_amt                  -- 存单可用金额
   ,dep_rcpt_acct_bal                  -- 存单账户余额
   ,estate_mon_prop_fee                -- 房产月物业费
   ,estate_arch_area                   -- 房产建筑面积
   ,remark                             -- 备注
   ,job_cd
   ,etl_timestamp
)
select
   to_date('${batch_date}', 'yyyymmdd')                             -- 数据日期
   ,t1.lp_id                                                          -- 法人编号
   ,t1.asset_id                                                       -- 押品编号
   ,t1.col_type_id                                                    -- 押品类型编号
   ,t1.col_name                                                     -- 押品名称
   ,''                                                                 -- 担保方式代码    --新系统无此信息项
   ,t1.col_mgmt_id                                                    -- 押品管理员工编号
   ,nvl(trim(t10.insto_org_id), t1.col_mgmt_org_id)                -- 机构编号
--   ,nvl(t12.guartor_id，t8.all_cust_id)                              -- 权利人客户编号
   ,case when length(t8.all_cust_id) >12 and  trim(t12.guartor_id) is not null then t12.guartor_id
          else t8.all_cust_id end                                  -- 权利人客户编号    --押品系统1024上线后会对客户号进行治理，治理完成前先这么取，后续可以去掉
   ,nvl(t8.all_cust_name,t12.guartor_name)                          -- 所有权人名称
   ,t1.com_prot_flg                                                   -- 共同财产标志
   ,t1.asset_obg_lot                                                  -- 资产权利人所占份额
   ,t1.prior_comp_weight_qtty                                         --优先受偿权数额 
   ,t1.guar_effect_way_cd                                             -- 担保生效方式代码
   ,t1.trast_insure_flg                                               -- 办理保险标志
   ,t1.col_rgst_trast_status_cd                                       -- 登记办理状态代码
   ,t1.col_insure_trast_status_cd                                     -- 保险办理状态代码
   ,t1.col_insto_status_cd                                            -- 入库状态代码
   ,t1.col_rela_status_cd                                        　   -- 关联状态代码
   ,t1.col_espec_status_cd                                       　   -- 特殊状态代码
   ,t1.wt_md_cash_ability_cd                                     　   -- 权重法变现能力代码
   ,t1.np_cash_ability_cd                                       　    -- 内评初级法变现能力代码
   ,t1.obank_guar_flg                                                 -- 他行担保标志
   ,t1.gcust_flg                                                      -- 代保管标志
   ,t1.fst_flg                                                        -- 我行第一顺位标志
   ,t1.curr_cd                                                   　   -- 评估币种代码
   ,t1.col_val                                                   　   -- 评估价值
   ,nvl(t3.estim_way_cd, '00')                                       -- 评估方式代码
   ,t3.estim_idtfy_dt                                                  -- 估值日期
   ,case when t3.estim_way_cd='01' then t5.appraisalorgname  --外部评估取评估公司名称
         when t3.estim_way_cd='02' then '华兴银行'  --内评取华兴银行
         when t3.estim_way_cd='03' then t5.appraisalorgname  --内外评取评估公司名称
         else '' end                                                 -- 评估人名称
   ,case when t3.estim_way_cd in ('01','03') then t3.ext_estim_exp_dt
         else null end                                            -- 评估到期日期
   ,nvl(t10.amt,0)                                                   -- 押品价值
   ,nvl(t3.hxb_cfm_val, t1.col_val)                                  -- 我行确认价值
   ,case when t11.guarantysum=0 then t11.guarantysum
         else (case when t11.guarantysum > decode(t1.col_val,0.00,t3.hxb_cfm_val,t1.col_val)
                    then decode(t1.col_val,0.00,t3.hxb_cfm_val,t1.col_val)
                    else t11.guarantysum end)
          end                                                        -- 已抵押价值
   ,t2.issue_dt                                                       -- 权利登记日期
   ,t3.estim_idtfy_dt                                            　   -- 评估基准日
   ,nvl(t3.hxb_pa_cfm_val, t1.col_val)                               -- 我行初次评估价值
   ,t1.save_hxb_flg                                                   -- 保存我行标志
   ,t1.setup_dt                                                       -- 建立日期
   ,''                                                                -- 核保日期   --无迁移
   ,''                                                                -- 核保人姓名1           --无迁移
   ,''                                                                -- 核保人姓名2          --无迁移
   ,t1.modif_emply_id                                                 -- 修改员工编号
   ,''                                                                -- 主押品标志    --生产没数据，下线
   ,t1.col_rgst_b_type_cd                                             -- 抵质押品标志
   ,t1.modifbl_flg                                                    -- 押品修改标志
   ,case when length(t8.all_cust_id) >12 and  trim(t12.guartor_id) is not null then t12.guartor_id
          else t8.all_cust_id end                                  -- 权利人客户编号
   ,t1.col_mgmt_org_id                                                -- 操作机构编号
   ,t2.licen_issue_autho_name                                         -- 登记机构名称
   ,t2.insto_dt                                                       -- 实物收取日期
   ,case when (nvl(t11.guarantysum,0)=0 or t1.col_val=0) then null
         when nvl(t11.guarantysum,0) > t1.col_val then 100
         else (t11.guarantysum/t1.col_val)*100 end                 -- 抵质押率
   ,t6.maxltv                                                         -- 最高抵押率   --后续确认规则   select a.maxltv from clr_param 
   ,t3.curr_cd                                                        -- 押品评估币种代码
   ,case when t3.estim_way_cd in('01','03') and t3.ext_pre_estim_flg = '1'
         then nvl(decode(t3.ext_estim_val,0,'',t3.ext_estim_val),t3.ext_pre_estim_val)
         when t3.estim_way_cd in('01','03') and t3.ext_pre_estim_flg = '0'
         then nvl(decode(t3.ext_pre_estim_val,0,'',t3.ext_pre_estim_val),t3.ext_estim_val)
         when t3.estim_way_cd='02' then trim(t3.intnal_estim_val)
         else '0'
         end                                                          -- 押品评估价值
   ,t4.address                                                         -- 押品存放地址
   ,case when t8.pmo_obg_brwer_rela_cd='01' and t1.com_prot_flg='0' then '2'  --抵质押品权利人为借款人且是否共同财产为否或空：自有
         when t8.pmo_obg_brwer_rela_cd in('02','03') and t1.com_prot_flg='1' then '3'  --（抵质押品权利人为关联第三方或抵质押品权利人为无关联第三方）且是否共同财产为是：共有
         when t8.pmo_obg_brwer_rela_cd in('02','03') and t1.com_prot_flg='0' then '1'  --（抵质押品权利人为关联第三方或抵质押品权利人为无关联第三方）且是否共同财产为否：他有
         else '' end                                                 -- 押品权属类型代码
   ,t5.appraisalorgname                                                -- 评估机构名称
   ,case when length(t5.appraisalcertid)=10  and substr(t5.appraisalcertid,9,1)='-' then t5.appraisalcertid
         when length(t5.appraisalcertid)=9 then substr(t5.appraisalcertid,1,8)||'-'||substr(t5.appraisalcertid,9,1)
         when length(t5.appraisalcertid)=18 then substr(t5.appraisalcertid,9,8)||'-'||substr(t5.appraisalcertid,17,1)
         else '' end                                                -- 评估机构证件号码
   ,t13.orgname                                                        -- 评估机构登记机关名称
   ,t8.all_cust_name                                                   -- 权属人名称
   ,t8.cert_type_cd                                                    -- 出质人证件类型代码
   ,t8.cert_no                                                         -- 出质人证件号码
   ,t2.wat_type_cd                                                     -- 权证类型代码
   ,t2.wat_num                                                         -- 权证登记号码二
   ,t2.licen_issue_autho_name                                          -- 权属登记机关
   ,t2.wat_num                                                         -- 权证登记号码
   ,t2.wat_name                                                        -- 权证名称
   ,t4.iscompleted                                                     -- 竣工标志
   ,t4.isrents                                                         -- 租赁标志
   ,t4.hpaddr                                                          -- 担保品承租人
   ,decode(${iml_schema}.dateformat_max2(t4.hiresdate), to_date('29991231', 'yyyymmdd'), null, ${iml_schema}.dateformat_max2(t4.hiresdate)) -- 租赁起始日期
   ,decode(${iml_schema}.dateformat_max2(t4.hireedate), to_date('29991231', 'yyyymmdd'), null, ${iml_schema}.dateformat_max2(t4.hireedate)) -- 租赁到期日期
   ,t4.hireremark                                                      -- 租赁情况描述
   ,decode(${iml_schema}.dateformat_max2(t2.rgst_end_dt), to_date('29991231', 'yyyymmdd'), null, ${iml_schema}.dateformat_max2(t2.rgst_end_dt)) -- 登记到期日期
   ,(case when ${iml_schema}.dateformat_max2(t2.rgst_end_dt) = to_date('29991231', 'yyyymmdd') or ${iml_schema}.dateformat_max2(t2.rgst_start_dt) = to_date('29991231', 'yyyymmdd') then 0
          else ${iml_schema}.dateformat_max2(t2.rgst_end_dt) - ${iml_schema}.dateformat_max2(t2.rgst_start_dt)
      end)                                                            -- 登记期限
   ,t2.rgst_emply_id                                                   -- 登记人编号
  ,t3.insto_org_id                                                     -- 入库记账机构编号
  ,t3.entry_col_val                                                    -- 入库记账价值
  ,t3.curr_cd                                                          -- 入库记账币种代码
  ,t2.insto_dt                                                         -- 入库日期
  ,t2.valid_closing_dt                                                 -- 到期日期
  ,t7.vouch_no                                                         -- 存单凭证编号
  ,case when t1.col_type_id in ('60010020010','60010020020','60010020030','60010020040') 
          then '1' else '0' end                                    -- 我行存单标志
  ,t7.effect_dt                                                        -- 存单生效日期
  ,t7.exp_dt                                                           -- 存单到期日期
  ,t7.dep_term                                                         -- 存单存期
  ,t7.dep_term                                                         -- 存单存期天数
  ,t7.dep_rcpt_int_rat                                                 -- 存单利率
  ,t7.curr_cd                                                          -- 存单币种代码
  ,t7.dep_rcpt_amt                                                     -- 存单可用金额
  ,t7.aval_amt                                                         -- 存单账户余额
  ,t9.monly_mgmt_fee                                                   -- 房产月物业费
  ,t9.arch_area                                                        -- 房产建筑面积
  ,t7.other_comnt                                                      -- 备注
   ,t1.job_cd                                                          -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- etl处理时间戳
from ${iml_schema}.ast_col_basic_info t1
 left join (select a.*
                      ,row_number() over(partition by asset_id order by wat_id desc) rn
                  from ${iml_schema}.ast_col_wat_info a
                 where create_dt <= to_date('${batch_date}','yyyymmdd')
                    and id_mark <> 'D'
                    and job_cd ='icmsf1'
              ) t2
   on t2.asset_id = t1.asset_id
and t2.rn = 1
  left join ${iml_schema}.ast_col_val_info_h t3
   on t1.asset_id = t3.asset_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd ='icmsf1'
 left join ${icl_schema}.tmp_cmm_col_info_02 t4
   on t4.clrid = t1.asset_id
 left join ${iol_schema}.icms_appraisal_agency t5
   on t3.ext_estim_org_id = t5.appraisalorgid
  and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.icms_clr_param t6  
   on t1.col_type_id = t6.clrtypeid
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.ast_col_dep_rcpt_inpwn_info t7
   on t1.asset_id = t7.col_id
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd ='icmsf1'
  left join (select t.*
                        ,row_number() over(partition by asset_id order by seq_num) rn
                   from ${iml_schema}.ast_col_all_info_h t
                  where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   　and end_dt > to_date('${batch_date}', 'yyyymmdd')
                     and job_cd ='icmsf1') t8
    on t1.asset_id = t8.asset_id
  and t8.rn = 1
 left join (select a.asset_id, a.monly_mgmt_fee, a.arch_area
                  from ${iml_schema}.ast_col_resd_build_info a
                 where create_dt <= to_date('${batch_date}','yyyymmdd')
                    and id_mark <> 'D'
                    and job_cd ='icmsf1'
                union
                select b.asset_id, b.monly_mgmt_fee, b.arch_area
                  from ${iml_schema}.ast_col_comer_build_info b
                 where create_dt <= to_date('${batch_date}','yyyymmdd')
                   and id_mark <> 'D'
                   and job_cd ='icmsf1' ) t9
   on t1.asset_id = t9.asset_id
 left join ${icl_schema}.tmp_cmm_col_info_01 t10
  on t1.asset_id = t10.asset_id
 left join (select clrid
                   ,sum(guarantysum) as  guarantysum
                  from ${iol_schema}.icms_clr_business_relative
                 where start_dt <= to_date('${batch_date}','yyyymmdd')
                    and end_dt > to_date('${batch_date}','yyyymmdd')
                 group by clrid) t11
   on t1.asset_id = t11.clrid
 left join ${iml_schema}.ast_col_guar_info t12
   on t12.col_id = t1.asset_id
  and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  and t12.job_cd ='icmsf1'
 left join ${iol_schema}.icms_org_info t13
   on t5.parentorgid = t13.orgid
  and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t13.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
  and t1.job_cd ='icmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_col_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_col_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_col_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_col_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_col_info_02 purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_col_info',partname => 'p_${batch_date}', degree => 8, cascade => true);