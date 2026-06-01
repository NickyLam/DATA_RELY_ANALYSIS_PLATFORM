/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline                                                              
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_ckftphz_insert_back
CreateDate: 20180515                                                             
FileType:   DML                                                                  
Logs:                                                                            
    zjj 2018-05-15 新建表本                                                      
*/
BEGIN
  FOR tjrq_rec IN (SELECT DISTINCT tjrq FROM ${itl_schema}.itl_edw_pams_jxbb_ckftphz_recal WHERE tjrq IS NOT NULL and etl_dt = to_date('${batch_date}','yyyyMMdd')) LOOP
    -- 删除分区（忽略错误）
    BEGIN
      EXECUTE IMMEDIATE 'ALTER TABLE ${itl_schema}.itl_edw_pams_jxbb_ckftphz DROP PARTITION p_' || tjrq_rec.tjrq;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    -- 创建新分区
    EXECUTE IMMEDIATE 'ALTER TABLE ${itl_schema}.itl_edw_pams_jxbb_ckftphz ADD PARTITION p_' || tjrq_rec.tjrq || ' VALUES (TO_DATE(''' || tjrq_rec.tjrq || ''', ''YYYYMMDD''))';

    -- 插入数据
    EXECUTE IMMEDIATE 'INSERT INTO ${itl_schema}.itl_edw_pams_jxbb_ckftphz PARTITION (p_' || tjrq_rec.tjrq || ') 
    (etl_dt, 
     tjrq, 
     kmh, 
     kmmc, 
     cpmc, 
     zhye, 
     zhyrjye, 
     zhnrjye, 
     jqll, 
     ftplxzcylj, 
     ftplxzcnlj, 
     jqftpjg, 
     ftpsrylj, 
     ftpsrnlj, 
     ftpsyylj, 
     ftpsynlj, 
     lxkm, 
     lxkmmc, 
     khjgh, 
     khjgmc, 
     ssjgh, 
     ssjgmc, 
     bz) 
    SELECT 
    to_date(tjrq,''yyyymmdd''), 
     tjrq, 
     kmh, 
     kmmc, 
     cpmc, 
     zhye, 
     zhyrjye, 
     zhnrjye, 
     jqll, 
     ftplxzcylj, 
     ftplxzcnlj, 
     jqftpjg, 
     ftpsrylj, 
     ftpsrnlj, 
     ftpsyylj, 
     ftpsynlj, 
     lxkm, 
     lxkmmc, 
     khjgh, 
     khjgmc, 
     ssjgh, 
     ssjgmc, 
     bz
    FROM ${itl_schema}.itl_edw_pams_jxbb_ckftphz_recal PARTITION (p_${batch_date} ) WHERE tjrq = ''' || tjrq_rec.tjrq || '''';

  END LOOP;
  COMMIT;
END;
/